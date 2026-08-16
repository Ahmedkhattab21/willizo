import Foundation

struct WatchWorkoutSnapshot: Codable, Equatable {
  let schemaVersion: Int
  let generatedAt: String
  let date: String
  let summary: WatchHomeSummary?
  let workout: ScheduledWatchWorkout?
  let meals: [WatchMeal]?
}

struct WatchHomeSummary: Codable, Equatable {
  let sessionsCount: Int?
  let sessionsDurationMinutes: Int?
  let mealsCount: Int?
  let mealsCalories: Int?
  let consumedCalories: Int?
  let dailyCalorieGoal: Int?

  enum CodingKeys: String, CodingKey {
    case sessionsCount = "sessions_count"
    case sessionsDurationMinutes = "sessions_duration_minutes"
    case mealsCount = "meals_count"
    case mealsCalories = "meals_calories"
    case consumedCalories = "consumed_calories"
    case dailyCalorieGoal = "daily_calorie_goal"
  }
}

struct ScheduledWatchWorkout: Codable, Equatable {
  let scheduledWorkoutId: Int
  let scheduledTime: String
  let isCompleted: Bool
  let plan: WatchWorkoutPlan
}

struct WatchWorkoutPlan: Codable, Equatable {
  let id: Int
  let name: String
  let slug: String
  let difficulty: String
  let category: String?
  let durationMinutes: Int?
  let caloriesBurned: Int?
  let exercises: [WatchExercise]
}

struct WatchExercise: Codable, Equatable, Identifiable {
  let id: Int
  let exerciseId: String
  let name: String
  let sets: Int
  let reps: Int
  let weight: Double?
  let previousSet: PreviousSet?
  let restSeconds: Int
  let order: Int
  let unit: String
  let category: String?

  var safeSetCount: Int {
    max(sets, 1)
  }

  var safeRestSeconds: Int {
    max(restSeconds, 0)
  }
}

struct WatchMeal: Codable, Equatable, Identifiable {
  let id: Int
  let mealType: String
  let name: String
  let calories: Int?
  let isCompleted: Bool
  let scheduledTime: String?
}

struct PreviousSet: Codable, Equatable {
  let reps: Int?
  let weight: Double?
}

struct WorkoutSessionState: Codable, Equatable {
  enum Status: String, Codable {
    case idle
    case active
    case paused
    case resting
    case finished
  }

  var status: Status = .idle
  var currentExerciseIndex: Int = 0
  var currentSetIndex: Int = 0
  var workoutPlanSlug: String?
  var startedAt: Date?
  var pausedAt: Date?
  var accumulatedPausedDuration: TimeInterval = 0
  var finishedAt: Date?
  var completedSets: [CompletedWorkoutSet] = []

  static let empty = WorkoutSessionState()

  private enum CodingKeys: String, CodingKey {
    case status
    case currentExerciseIndex
    case currentSetIndex
    case workoutPlanSlug
    case startedAt
    case pausedAt
    case accumulatedPausedDuration
    case finishedAt
    case completedSets
  }

  init() {}

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    status = try container.decodeIfPresent(Status.self, forKey: .status) ?? .idle
    currentExerciseIndex = try container.decodeIfPresent(Int.self, forKey: .currentExerciseIndex) ?? 0
    currentSetIndex = try container.decodeIfPresent(Int.self, forKey: .currentSetIndex) ?? 0
    workoutPlanSlug = try container.decodeIfPresent(String.self, forKey: .workoutPlanSlug)
    startedAt = try container.decodeIfPresent(Date.self, forKey: .startedAt)
    pausedAt = try container.decodeIfPresent(Date.self, forKey: .pausedAt)
    accumulatedPausedDuration = try container.decodeIfPresent(
      TimeInterval.self,
      forKey: .accumulatedPausedDuration
    ) ?? 0
    finishedAt = try container.decodeIfPresent(Date.self, forKey: .finishedAt)
    completedSets = try container.decodeIfPresent([CompletedWorkoutSet].self, forKey: .completedSets) ?? []
  }
}

struct CompletedWorkoutSet: Codable, Equatable, Identifiable {
  let id: UUID
  let exerciseId: String
  let exerciseName: String
  let setNumber: Int
  let reps: Int
  let weight: Double?
  let completedAt: Date
}

struct WorkoutResultPayload: Codable, Equatable {
  let resultId: UUID
  let scheduledWorkoutId: Int
  let workoutPlanId: Int
  let finishedAt: Date
  let completedSets: [CompletedWorkoutSet]
}

struct WatchWorkoutCompletionSummary: Codable, Equatable {
  let workoutName: String?
  let workoutCategory: String?
  let finishedAt: Date?
  let actualDurationMinutes: Int?
  let goalProgress: Double?
  let calories: Int?
  let calorieGoal: Int?
  let averageHeartRate: Int?
  let maxHeartRate: Int?
  let distanceKilometers: Double?
  let averagePower: Int?
  let recoveryMinutes: Int?
  let heartRateZones: WatchHeartRateZones
  let achievements: [WatchWorkoutAchievement]

  var hasStatistics: Bool {
    actualDurationMinutes != nil
      || goalProgress != nil
      || calories != nil
      || averageHeartRate != nil
      || maxHeartRate != nil
      || distanceKilometers != nil
      || averagePower != nil
      || recoveryMinutes != nil
      || heartRateZones != .empty
      || !achievements.isEmpty
  }

  static let empty = WatchWorkoutCompletionSummary(
    workoutName: nil,
    workoutCategory: nil,
    finishedAt: nil,
    actualDurationMinutes: nil,
    goalProgress: nil,
    calories: nil,
    calorieGoal: nil,
    averageHeartRate: nil,
    maxHeartRate: nil,
    distanceKilometers: nil,
    averagePower: nil,
    recoveryMinutes: nil,
    heartRateZones: .empty,
    achievements: []
  )
}

struct WatchHeartRateZones: Codable, Equatable {
  let peak: Double?
  let cardio: Double?
  let fatBurn: Double?
  let warmUp: Double?

  static let empty = WatchHeartRateZones(peak: nil, cardio: nil, fatBurn: nil, warmUp: nil)
}

struct WatchWorkoutAchievement: Codable, Equatable, Identifiable {
  let id: String
  let title: String
  let subtitle: String?
  let systemImage: String
}

struct WatchWorkoutPlanSummary: Codable, Equatable, Identifiable {
  let id: Int
  let name: String
  let slug: String
  let difficulty: String
  let durationMinutes: Int?
  let caloriesBurned: Int?
  let category: String
  let isFeatured: Bool

  enum CodingKeys: String, CodingKey {
    case id, name, slug, difficulty, category
    case durationMinutes = "duration_minutes"
    case caloriesBurned = "calories_burned"
    case isFeatured = "is_featured"
  }
}

struct WatchWorkoutPlanDetail: Codable, Equatable, Identifiable {
  let id: Int
  let name: String
  let slug: String
  let difficulty: String
  let durationMinutes: Int?
  let caloriesBurned: Int?
  let category: String
  let exercises: [WatchPlanExercise]

  enum CodingKeys: String, CodingKey {
    case id, name, slug, difficulty, category, exercises
    case durationMinutes = "duration_minutes"
    case caloriesBurned = "calories_burned"
  }
}

struct WatchPlanExercise: Codable, Equatable, Identifiable {
  let id: String
  let name: String
  let category: String?
  let unit: String
  let sets: Int?
  let reps: Int?
  let weight: Double?
  let durationSeconds: Int?
  let restSeconds: Int?
  let order: Int

  enum CodingKeys: String, CodingKey {
    case id, name, category, unit, sets, reps, weight, order
    case durationSeconds = "duration_seconds"
    case restSeconds = "rest_seconds"
  }
}

struct WatchRecipeSummary: Codable, Equatable, Identifiable {
  let id: Int
  let name: String
  let slug: String
  let imageURL: String?
  let category: String
  let difficulty: String
  let calories: Int?

  enum CodingKeys: String, CodingKey {
    case id, name, slug, category, difficulty, calories
    case imageURL = "image_url"
  }
}

struct WatchRecipeDetail: Codable, Equatable, Identifiable {
  let id: Int
  let name: String
  let slug: String
  let imageURL: String?
  let category: String
  let bestTimeToEat: String?
  let nutrition: WatchRecipeNutrition
  let ingredients: [WatchRecipeIngredient]

  enum CodingKeys: String, CodingKey {
    case id, name, slug, category, nutrition, ingredients
    case imageURL = "image_url"
    case bestTimeToEat = "best_time_to_eat"
  }
}

struct WatchRecipeNutrition: Codable, Equatable {
  let calories: Int?
  let protein: Double?
  let carbs: Double?
  let fat: Double?
  let fiber: Double?
}

struct WatchRecipeIngredient: Codable, Equatable, Identifiable {
  let id: Int
  let name: String
  let amount: String?
  let order: Int
}
