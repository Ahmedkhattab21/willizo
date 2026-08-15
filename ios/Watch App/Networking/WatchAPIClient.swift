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

  func completeWorkout(id: Int, actualDuration: Int) async throws {
    _ = try await request(
      path: "/watch/workouts/\(id)/complete",
      method: "POST",
      body: ["actual_duration": actualDuration]
    )
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
}

private enum WatchAPIMapper {
  static func snapshot(home: Any, workouts: Any, meals: Any) -> WatchWorkoutSnapshot {
    let homeData = unwrap(home)
    let workoutItems = array(from: workouts, keys: ["workouts", "today_workouts", "todayWorkouts", "items"])
    let homeWorkoutItems = array(from: homeData, keys: ["workouts", "today_workouts", "todayWorkouts"])
    let workout = (workoutItems.first ?? homeWorkoutItems.first).flatMap(mapWorkout)
    let mealItems = array(from: meals, keys: ["meals", "today_meals", "todayMeals", "items"])
    let homeMealItems = array(from: homeData, keys: ["meals", "today_meals", "todayMeals"])

    return WatchWorkoutSnapshot(
      schemaVersion: 1,
      generatedAt: ISO8601DateFormatter().string(from: Date()),
      date: dateString(),
      workout: workout,
      meals: (mealItems.isEmpty ? homeMealItems : mealItems).compactMap(mapMeal)
    )
  }

  private static func mapWorkout(_ value: Any) -> ScheduledWatchWorkout? {
    guard let item = value as? [String: Any] else { return nil }
    let plan = dictionary(item["workout_plan"] ?? item["workoutPlan"] ?? item["plan"]) ?? item
    let exercises = array(from: plan, keys: ["workout_plan_exercises", "workoutPlanExercises", "exercises"])
      .compactMap(mapExercise)
      .sorted { $0.order < $1.order }
    return ScheduledWatchWorkout(
      scheduledWorkoutId: int(item["id"] ?? item["scheduled_workout_id"]),
      scheduledTime: string(item["scheduled_time"] ?? item["scheduledTime"]),
      isCompleted: bool(item["is_completed"] ?? item["isCompleted"]),
      plan: WatchWorkoutPlan(
        id: int(plan["id"]),
        name: string(plan["name"]),
        slug: string(plan["slug"]),
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
    return WatchExercise(
      id: int(item["id"] ?? exercise["id"]),
      exerciseId: string(item["exercise_id"] ?? exercise["id"]),
      name: string(exercise["name"] ?? item["name"]),
      sets: int(item["sets"]),
      reps: int(item["reps"] ?? item["value"]),
      weight: double(item["weight"]),
      previousSet: nil,
      restSeconds: int(item["rest_time"] ?? item["rest_seconds"] ?? 60),
      order: int(item["order"]),
      unit: string(exercise["unit"]),
      category: optionalString(exercise["category"])
    )
  }

  private static func mapMeal(_ value: Any) -> WatchMeal? {
    guard let item = value as? [String: Any] else { return nil }
    let recipe = dictionary(item["recipe"]) ?? item
    return WatchMeal(
      id: int(item["id"] ?? recipe["id"]),
      mealType: string(item["meal_type"] ?? item["mealType"]),
      name: string(recipe["name"] ?? item["name"]),
      calories: optionalInt(recipe["calories"] ?? item["calories"]),
      isCompleted: bool(item["is_completed"] ?? item["isCompleted"])
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
