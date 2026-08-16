import Foundation

enum WatchAPIError: LocalizedError {
  case unauthenticated
  case invalidURL
  case invalidResponse
  case server(Int)

  var errorDescription: String? {
    switch self {
    case .unauthenticated: return "Open the iPhone app to connect your account"
    case .invalidURL, .invalidResponse: return "Could not read the server response"
    case .server: return "Could not refresh your workout"
    }
  }
}

struct CreatedWatchWorkout {
  let id: Int?
  let startedAt: Date?
}

final class WatchAPIClient {
  private let auth: WatchAuthManager
  private let urlSession: URLSession
  private let connectivity: PhoneConnectivityService

  init(
    auth: WatchAuthManager,
    connectivity: PhoneConnectivityService,
    urlSession: URLSession = .shared
  ) {
    self.auth = auth
    self.connectivity = connectivity
    self.urlSession = urlSession
  }

  func fetchProfile() async throws {
    _ = try await request(path: "/watch/profile")
  }

  func fetchHomeSnapshot() async throws -> WatchWorkoutSnapshot {
    async let home = request(path: "/watch/home")
    async let workouts = request(path: "/watch/workouts/today")
    async let meals = request(path: "/watch/meals/today")
    let payloads = try await [home, workouts, meals]
    return WatchAPIMapper.snapshot(home: payloads[0], workouts: payloads[1], meals: payloads[2])
  }

  func completeWorkout(id: Int, actualDuration: Int) async throws -> WatchWorkoutCompletionSummary {
    let response = try await request(
      path: "/watch/workouts/\(id)/complete",
      method: "POST",
      body: ["actual_duration": actualDuration]
    )
    return completionSummary(from: response)
  }

  func createWorkoutLog(
    exerciseID: String,
    value: Int,
    workoutDate: String
  ) async throws -> CreatedWatchWorkout {
    let response = try await request(
      path: "/watch/workouts",
      method: "POST",
      body: [
        "exercise_id": exerciseID,
        "value": value,
        "workout_date": workoutDate,
        "notes": "Started from Apple Watch"
      ]
    )
    return CreatedWatchWorkout(
      id: responseID(from: response),
      startedAt: responseStartedAt(from: response)
    )
  }

  func fetchWorkoutPlans() async throws -> [WatchWorkoutPlanSummary] {
    let baseURL = auth.session?.baseURL ?? "https://willizo.com/api"
    guard let url = URL(string: normalizedBaseURL(baseURL) + "/watch/workout-plans") else {
      throw WatchAPIError.invalidURL
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Accept")

    let (data, response) = try await urlSession.data(for: request)
    guard let http = response as? HTTPURLResponse else { throw WatchAPIError.invalidResponse }
    guard (200...299).contains(http.statusCode) else { throw WatchAPIError.server(http.statusCode) }
    return try JSONDecoder().decode(WorkoutPlansResponse.self, from: data).workoutPlans
  }

  func fetchWorkoutPlan(slug: String) async throws -> WatchWorkoutPlanDetail {
    let baseURL = auth.session?.baseURL ?? "https://willizo.com/api"
    guard let encodedSlug = slug.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
          let url = URL(string: normalizedBaseURL(baseURL) + "/watch/workout-plans/\(encodedSlug)") else {
      throw WatchAPIError.invalidURL
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Accept")

    let (data, response) = try await urlSession.data(for: request)
    guard let http = response as? HTTPURLResponse else { throw WatchAPIError.invalidResponse }
    guard (200...299).contains(http.statusCode) else { throw WatchAPIError.server(http.statusCode) }
    return try JSONDecoder().decode(WorkoutPlanResponse.self, from: data).workoutPlan
  }

  func fetchLatestExerciseResult(exerciseID: String) async throws -> PreviousSet? {
    guard let encodedID = exerciseID.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
      throw WatchAPIError.invalidURL
    }
    let response = try await request(
      path: "/watch/workouts/history?limit=1&exercise_id=\(encodedID)"
    )
    guard let item = firstHistoryItem(from: response) else { return nil }
    let exercise = item["exercise"] as? [String: Any]
    let unit = (exercise?["unit"] as? String ?? item["unit"] as? String ?? "").lowercased()
    let reps = intValue(item["reps"])
      ?? (unit == "reps" ? intValue(item["value"]) : nil)
    let weight = doubleValue(item["weight"])
      ?? doubleValue(item["weight_kg"])
      ?? doubleValue(item["previous_weight"])
    guard reps != nil || weight != nil else { return nil }
    return PreviousSet(reps: reps, weight: weight)
  }

  func fetchRecipes() async throws -> [WatchRecipeSummary] {
    let baseURL = auth.session?.baseURL ?? "https://willizo.com/api"
    guard let url = URL(string: normalizedBaseURL(baseURL) + "/watch/recipes") else {
      throw WatchAPIError.invalidURL
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Accept")

    let (data, response) = try await urlSession.data(for: request)
    guard let http = response as? HTTPURLResponse else { throw WatchAPIError.invalidResponse }
    guard (200...299).contains(http.statusCode) else { throw WatchAPIError.server(http.statusCode) }
    return try JSONDecoder().decode(RecipesResponse.self, from: data).recipes
  }

  func fetchRecipe(slug: String) async throws -> WatchRecipeDetail {
    let baseURL = auth.session?.baseURL ?? "https://willizo.com/api"
    guard let encodedSlug = slug.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
          let url = URL(string: normalizedBaseURL(baseURL) + "/watch/recipes/\(encodedSlug)") else {
      throw WatchAPIError.invalidURL
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Accept")

    let (data, response) = try await urlSession.data(for: request)
    guard let http = response as? HTTPURLResponse else { throw WatchAPIError.invalidResponse }
    guard (200...299).contains(http.statusCode) else { throw WatchAPIError.server(http.statusCode) }
    return try JSONDecoder().decode(RecipeResponse.self, from: data).recipe
  }


  private func request(
    path: String,
    method: String = "GET",
    body: [String: Any]? = nil,
    retryAfterRefresh: Bool = true
  ) async throws -> Any {
    guard let session = auth.session else { throw WatchAPIError.unauthenticated }
    guard let url = URL(string: normalizedBaseURL(session.baseURL) + path) else {
      throw WatchAPIError.invalidURL
    }
    var request = URLRequest(url: url)
    request.httpMethod = method
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("Bearer \(session.accessToken)", forHTTPHeaderField: "Authorization")
    if let body {
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpBody = try JSONSerialization.data(withJSONObject: body)
    }

    let (data, response) = try await urlSession.data(for: request)
    guard let http = response as? HTTPURLResponse else { throw WatchAPIError.invalidResponse }
    if http.statusCode == 401, retryAfterRefresh {
      try await refreshSession(using: session)
      return try await self.request(
        path: path,
        method: method,
        body: body,
        retryAfterRefresh: false
      )
    }
    guard (200...299).contains(http.statusCode) else { throw WatchAPIError.server(http.statusCode) }
    guard !data.isEmpty else { return [:] }
    return try JSONSerialization.jsonObject(with: data)
  }

  private func refreshSession(using session: WatchAuthSession) async throws {
    guard let url = URL(string: normalizedBaseURL(session.baseURL) + "/auth/refresh") else {
      throw WatchAPIError.invalidURL
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.httpBody = try JSONSerialization.data(withJSONObject: ["refresh_token": session.refreshToken])

    let (data, response) = try await urlSession.data(for: request)
    guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode),
          let root = try JSONSerialization.jsonObject(with: data) as? [String: Any],
          let responseData = root["data"] as? [String: Any],
          let tokens = responseData["tokens"] as? [String: Any],
          let accessToken = tokens["access_token"] as? String,
          let refreshToken = tokens["refresh_token"] as? String else {
      auth.clear()
      throw WatchAPIError.unauthenticated
    }

    let refreshed = WatchAuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokens["token_type"] as? String ?? "bearer",
      expiresAt: (tokens["expires_in"] as? NSNumber).map {
        Date().addingTimeInterval($0.doubleValue)
      },
      baseURL: session.baseURL
    )
    auth.save(refreshed)
    connectivity.sendAuthSessionUpdate(refreshed.connectivityPayload)
  }

  private func normalizedBaseURL(_ value: String) -> String {
    value.hasSuffix("/") ? String(value.dropLast()) : value
  }

  private func responseID(from value: Any) -> Int? {
    guard let workout = responseWorkout(from: value) else { return nil }
    if let number = workout["id"] as? NSNumber { return number.intValue }
    if let string = workout["id"] as? String { return Int(string) }
    return nil
  }

  private func completionSummary(from value: Any) -> WatchWorkoutCompletionSummary {
    guard let root = value as? [String: Any] else { return .empty }
    let data = root["data"] as? [String: Any] ?? root
    let workout = data["workout"] as? [String: Any]
      ?? data["workout_summary"] as? [String: Any]
      ?? data["summary"] as? [String: Any]
      ?? data
    let plan = workout["workout_plan"] as? [String: Any]
      ?? workout["plan"] as? [String: Any]
      ?? data["workout_plan"] as? [String: Any]
      ?? [:]
    let metrics = workout["metrics"] as? [String: Any]
      ?? workout["stats"] as? [String: Any]
      ?? data["metrics"] as? [String: Any]
      ?? data["stats"] as? [String: Any]
      ?? [:]
    let zones = metrics["heart_rate_zones"] as? [String: Any]
      ?? workout["heart_rate_zones"] as? [String: Any]
      ?? data["heart_rate_zones"] as? [String: Any]
      ?? [:]
    let durationSeconds = firstInt(
      keys: ["actual_duration_seconds", "duration_seconds"],
      dictionaries: [metrics, workout, data, root]
    )
    let durationMinutes = firstInt(
      keys: ["actual_duration", "actual_duration_minutes", "duration_minutes"],
      dictionaries: [metrics, workout, data, root]
    ) ?? durationSeconds.map { max(($0 + 59) / 60, 1) }
    let percentValue = firstDouble(
      keys: ["goal_progress_percent", "progress_percent", "completion_percent"],
      dictionaries: [metrics, workout, data, root]
    )
    let progressValue = firstDouble(
      keys: ["goal_progress", "progress", "completion_progress"],
      dictionaries: [metrics, workout, data, root]
    )
    let finishedAt = firstString(
      keys: ["finished_at", "completed_at", "updated_at"],
      dictionaries: [workout, data, root]
    ).flatMap(parseAPIDate)

    return WatchWorkoutCompletionSummary(
      workoutName: firstString(keys: ["name", "workout_name", "title"], dictionaries: [plan, workout]),
      workoutCategory: firstString(keys: ["category", "workout_type", "type"], dictionaries: [plan, workout]),
      finishedAt: finishedAt,
      actualDurationMinutes: durationMinutes,
      goalProgress: normalizedProgress(percent: percentValue, progress: progressValue),
      calories: firstInt(
        keys: ["calories", "total_calories", "calories_burned", "active_calories"],
        dictionaries: [metrics, workout, data, root]
      ),
      calorieGoal: firstInt(
        keys: ["calorie_goal", "calories_goal", "target_calories"],
        dictionaries: [metrics, workout, data, root]
      ),
      averageHeartRate: firstInt(
        keys: ["average_heart_rate", "avg_heart_rate", "average_hr", "avg_hr"],
        dictionaries: [metrics, workout, data, root]
      ),
      maxHeartRate: firstInt(
        keys: ["max_heart_rate", "peak_heart_rate", "max_hr", "peak_hr"],
        dictionaries: [metrics, workout, data, root]
      ),
      distanceKilometers: firstDouble(
        keys: ["distance_km", "distance_kilometers"],
        dictionaries: [metrics, workout, data, root]
      ),
      averagePower: firstInt(
        keys: ["average_power", "avg_power", "watts"],
        dictionaries: [metrics, workout, data, root]
      ),
      recoveryMinutes: firstInt(
        keys: ["recovery_minutes", "recovery_time_minutes"],
        dictionaries: [metrics, workout, data, root]
      ),
      heartRateZones: WatchHeartRateZones(
        peak: zoneProgress(zones["peak"]),
        cardio: zoneProgress(zones["cardio"]),
        fatBurn: zoneProgress(zones["fat_burn"] ?? zones["fatBurn"]),
        warmUp: zoneProgress(zones["warm_up"] ?? zones["warmup"] ?? zones["warmUp"])
      ),
      achievements: completionAchievements(from: workout, data: data, root: root)
    )
  }

  private func firstInt(keys: [String], dictionaries: [[String: Any]]) -> Int? {
    for dictionary in dictionaries {
      for key in keys {
        if let value = intValue(dictionary[key]) { return value }
      }
    }
    return nil
  }

  private func firstDouble(keys: [String], dictionaries: [[String: Any]]) -> Double? {
    for dictionary in dictionaries {
      for key in keys {
        if let value = doubleValue(dictionary[key]) { return value }
      }
    }
    return nil
  }

  private func firstString(keys: [String], dictionaries: [[String: Any]]) -> String? {
    for dictionary in dictionaries {
      for key in keys {
        if let value = dictionary[key] as? String,
           !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
          return value
        }
      }
    }
    return nil
  }

  private func normalizedProgress(percent: Double?, progress: Double?) -> Double? {
    guard let raw = percent.map({ $0 / 100 }) ?? progress else { return nil }
    let normalized = raw > 1 ? raw / 100 : raw
    return min(max(normalized, 0), 1)
  }

  private func zoneProgress(_ value: Any?) -> Double? {
    let raw: Double?
    if let dictionary = value as? [String: Any] {
      raw = doubleValue(dictionary["percent"] ?? dictionary["percentage"] ?? dictionary["value"])
    } else {
      raw = doubleValue(value)
    }
    guard let raw else { return nil }
    return min(max(raw > 1 ? raw / 100 : raw, 0), 1)
  }

  private func completionAchievements(
    from workout: [String: Any],
    data: [String: Any],
    root: [String: Any]
  ) -> [WatchWorkoutAchievement] {
    let items = workout["achievements"] as? [[String: Any]]
      ?? data["achievements"] as? [[String: Any]]
      ?? root["achievements"] as? [[String: Any]]
      ?? []
    return items.enumerated().compactMap { index, item in
      guard let title = firstString(keys: ["title", "name"], dictionaries: [item]) else { return nil }
      return WatchWorkoutAchievement(
        id: firstString(keys: ["id", "slug"], dictionaries: [item]) ?? "\(index)-\(title)",
        title: title,
        subtitle: firstString(keys: ["subtitle", "description", "message"], dictionaries: [item]),
        systemImage: firstString(keys: ["system_image", "icon"], dictionaries: [item]) ?? "trophy.fill"
      )
    }
  }

  private func parseAPIDate(_ raw: String) -> Date? {
    Self.apiTimestampFormatter.date(from: raw)
      ?? Self.apiTimestampWithoutFractionsFormatter.date(from: raw)
  }

  private func responseStartedAt(from value: Any) -> Date? {
    guard let workout = responseWorkout(from: value) else { return nil }
    guard let raw = workout["started_at"] as? String, !raw.isEmpty else { return nil }
    return Self.apiTimestampFormatter.date(from: raw)
      ?? Self.apiTimestampWithoutFractionsFormatter.date(from: raw)
  }

  private func responseWorkout(from value: Any) -> [String: Any]? {
    guard let root = value as? [String: Any] else { return nil }
    let data = root["data"] as? [String: Any] ?? root
    return data["workout"] as? [String: Any] ?? data
  }

  private func firstHistoryItem(from value: Any) -> [String: Any]? {
    if let items = value as? [[String: Any]] { return items.first }
    guard let root = value as? [String: Any] else { return nil }
    if let dataItems = root["data"] as? [[String: Any]] { return dataItems.first }
    let data = root["data"] as? [String: Any] ?? root
    for key in ["workouts", "history", "items", "data"] {
      if let items = data[key] as? [[String: Any]] { return items.first }
    }
    return nil
  }

  private func intValue(_ value: Any?) -> Int? {
    if let number = value as? NSNumber { return number.intValue }
    if let string = value as? String { return Int(string) }
    return nil
  }

  private func doubleValue(_ value: Any?) -> Double? {
    if let number = value as? NSNumber { return number.doubleValue }
    if let string = value as? String { return Double(string) }
    return nil
  }

  private static let apiTimestampFormatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter
  }()

  private static let apiTimestampWithoutFractionsFormatter = ISO8601DateFormatter()
}

private struct WorkoutPlansResponse: Decodable {
  let workoutPlans: [WatchWorkoutPlanSummary]

  enum CodingKeys: String, CodingKey {
    case workoutPlans = "workout_plans"
  }
}

private struct WorkoutPlanResponse: Decodable {
  let workoutPlan: WatchWorkoutPlanDetail

  enum CodingKeys: String, CodingKey {
    case workoutPlan = "workout_plan"
  }
}

private struct RecipesResponse: Decodable {
  let recipes: [WatchRecipeSummary]
}

private struct RecipeResponse: Decodable {
  let recipe: WatchRecipeDetail
}

private enum WatchAPIMapper {
  static func snapshot(home: Any, workouts: Any, meals: Any) -> WatchWorkoutSnapshot {
    let homeData = unwrap(home)
    let summaryData = dictionary(homeData["summary"])
    let workoutItems = array(from: workouts, keys: ["workouts", "today_workouts", "todayWorkouts", "items"])
    let homeWorkoutItems = array(from: homeData, keys: ["workouts", "today_workouts", "todayWorkouts"])
    let workout = (workoutItems.first ?? homeWorkoutItems.first).flatMap(mapWorkout)
    let mealItems = array(from: meals, keys: ["meals", "today_meals", "todayMeals", "items"])
    let homeMealItems = array(from: homeData, keys: ["meals", "today_meals", "todayMeals"])

    return WatchWorkoutSnapshot(
      schemaVersion: 1,
      generatedAt: ISO8601DateFormatter().string(from: Date()),
      date: dateString(),
      summary: summaryData.map(mapHomeSummary),
      workout: workout,
      meals: (mealItems.isEmpty ? homeMealItems : mealItems).compactMap(mapMeal)
    )
  }

  private static func mapWorkout(_ value: Any) -> ScheduledWatchWorkout? {
    guard let item = value as? [String: Any] else { return nil }
    let plan = dictionary(item["workout_plan"] ?? item["workoutPlan"] ?? item["plan"]) ?? item
    let scheduledWorkoutID = int(item["id"] ?? item["scheduled_workout_id"])
    let planID = int(plan["id"])
    let name = string(plan["name"])
    let slug = string(plan["slug"])
    guard scheduledWorkoutID > 0, planID > 0, !name.isEmpty, !slug.isEmpty else { return nil }
    let exercises = array(from: plan, keys: ["workout_plan_exercises", "workoutPlanExercises", "exercises"])
      .compactMap(mapExercise)
      .sorted { $0.order < $1.order }
    return ScheduledWatchWorkout(
      scheduledWorkoutId: scheduledWorkoutID,
      scheduledTime: string(item["scheduled_time"] ?? item["scheduledTime"]),
      isCompleted: bool(item["is_completed"] ?? item["isCompleted"]),
      plan: WatchWorkoutPlan(
        id: planID,
        name: name,
        slug: slug,
        difficulty: string(plan["difficulty"]),
        category: optionalString(plan["category"]),
        durationMinutes: optionalInt(plan["duration_minutes"] ?? plan["duration"]),
        caloriesBurned: optionalInt(plan["calories_burned"] ?? plan["calories"]),
        exercises: exercises
      )
    )
  }

  private static func mapExercise(_ value: Any) -> WatchExercise? {
    guard let item = value as? [String: Any] else { return nil }
    let exercise = dictionary(item["exercise"]) ?? item
    let exerciseID = string(item["exercise_id"] ?? exercise["id"])
    let name = string(exercise["name"] ?? item["name"])
    guard
      !exerciseID.isEmpty,
      !name.isEmpty,
      let sets = optionalInt(item["sets"]),
      let reps = optionalInt(item["reps"] ?? item["value"]),
      let restSeconds = optionalInt(item["rest_time"] ?? item["rest_seconds"])
    else { return nil }
    return WatchExercise(
      id: int(item["id"] ?? exercise["id"]),
      exerciseId: exerciseID,
      name: name,
      sets: sets,
      reps: reps,
      weight: double(item["weight"]),
      previousSet: nil,
      restSeconds: restSeconds,
      order: int(item["order"]),
      unit: string(exercise["unit"]),
      category: optionalString(exercise["category"])
    )
  }

  private static func mapMeal(_ value: Any) -> WatchMeal? {
    guard let item = value as? [String: Any] else { return nil }
    let recipe = dictionary(item["recipe"]) ?? item
    let id = int(item["id"] ?? recipe["id"])
    let name = string(recipe["name"] ?? item["name"])
    guard id > 0, !name.isEmpty else { return nil }
    return WatchMeal(
      id: id,
      mealType: string(item["meal_type"] ?? item["mealType"]),
      name: string(recipe["name"] ?? item["name"]),
      calories: optionalInt(recipe["calories"] ?? item["calories"]),
      isCompleted: bool(item["is_completed"] ?? item["isCompleted"]),
      scheduledTime: optionalString(
        item["scheduled_time"] ?? item["scheduledTime"] ?? item["meal_time"] ?? item["time"]
      )
    )
  }

  private static func mapHomeSummary(_ value: [String: Any]) -> WatchHomeSummary {
    WatchHomeSummary(
      sessionsCount: optionalInt(value["sessions_count"]),
      sessionsDurationMinutes: optionalInt(value["sessions_duration_minutes"]),
      mealsCount: optionalInt(value["meals_count"]),
      mealsCalories: optionalInt(value["meals_calories"]),
      consumedCalories: optionalInt(value["consumed_calories"]),
      dailyCalorieGoal: optionalInt(value["daily_calorie_goal"])
    )
  }

  private static func unwrap(_ value: Any) -> [String: Any] {
    guard let root = value as? [String: Any] else { return [:] }
    return dictionary(root["data"]) ?? root
  }

  private static func array(from value: Any, keys: [String]) -> [Any] {
    if let array = value as? [Any] { return array }
    guard let object = value as? [String: Any] else { return [] }
    let data = dictionary(object["data"]) ?? object
    for key in keys {
      if let array = data[key] as? [Any] { return array }
      if let object = data[key] as? [String: Any] { return [object] }
    }
    return []
  }

  private static func dictionary(_ value: Any?) -> [String: Any]? { value as? [String: Any] }
  private static func string(_ value: Any?) -> String {
    guard let value, !(value is NSNull) else { return "" }
    return String(describing: value)
  }
  private static func optionalString(_ value: Any?) -> String? {
    let result = string(value)
    return result.isEmpty ? nil : result
  }
  private static func int(_ value: Any?) -> Int { optionalInt(value) ?? 0 }
  private static func optionalInt(_ value: Any?) -> Int? {
    if let number = value as? NSNumber { return number.intValue }
    if let string = value as? String { return Int(string) }
    return nil
  }
  private static func double(_ value: Any?) -> Double? {
    if let number = value as? NSNumber { return number.doubleValue }
    if let string = value as? String { return Double(string) }
    return nil
  }
  private static func bool(_ value: Any?) -> Bool {
    if let bool = value as? Bool { return bool }
    if let number = value as? NSNumber { return number.boolValue }
    if let string = value as? String { return ["true", "1"].contains(string.lowercased()) }
    return false
  }
  private static func dateString() -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: Date())
  }
}
