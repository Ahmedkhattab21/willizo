import Foundation

struct WatchWorkoutSnapshot: Codable, Equatable {
  let schemaVersion: Int
  let generatedAt: String
  let date: String
  let workout: ScheduledWatchWorkout?
  let meals: [WatchMeal]?
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
  var startedAt: Date?
  var finishedAt: Date?
  var completedSets: [CompletedWorkoutSet] = []

  static let empty = WorkoutSessionState()
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
