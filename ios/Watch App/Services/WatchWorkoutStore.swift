import Foundation

final class WatchWorkoutStore {
  private enum Keys {
    static let snapshot = "watch.snapshot"
    static let session = "watch.session"
    static let unsyncedResults = "watch.unsyncedResults"
    static let workoutPlans = "watch.workoutPlans"
    static let workoutPlanDetails = "watch.workoutPlanDetails"
    static let recipes = "watch.recipes"
    static let recipeDetails = "watch.recipeDetails"
    static let completionSummaries = "watch.completionSummaries"
  }

  private let defaults: UserDefaults
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()

  init(defaults: UserDefaults = .standard) {
    self.defaults = defaults
  }

  func saveSnapshot(_ snapshot: WatchWorkoutSnapshot) {
    encode(snapshot, key: Keys.snapshot)
  }

  func loadSnapshot() -> WatchWorkoutSnapshot? {
    decode(WatchWorkoutSnapshot.self, key: Keys.snapshot)
  }

  func saveSession(_ session: WorkoutSessionState) {
    encode(session, key: Keys.session)
  }

  func loadSession() -> WorkoutSessionState {
    decode(WorkoutSessionState.self, key: Keys.session) ?? .empty
  }

  func clearSession() {
    defaults.removeObject(forKey: Keys.session)
  }

  func clearPrivateData() {
    defaults.removeObject(forKey: Keys.snapshot)
    defaults.removeObject(forKey: Keys.session)
    defaults.removeObject(forKey: Keys.unsyncedResults)
    defaults.removeObject(forKey: Keys.workoutPlans)
    defaults.removeObject(forKey: Keys.workoutPlanDetails)
    defaults.removeObject(forKey: Keys.recipes)
    defaults.removeObject(forKey: Keys.recipeDetails)
    defaults.removeObject(forKey: Keys.completionSummaries)
  }

  func appendUnsyncedResult(_ result: WorkoutResultPayload) {
    var results = loadUnsyncedResults()
    results.append(result)
    encode(results, key: Keys.unsyncedResults)
  }

  func loadUnsyncedResults() -> [WorkoutResultPayload] {
    decode([WorkoutResultPayload].self, key: Keys.unsyncedResults) ?? []
  }

  func replaceUnsyncedResults(_ results: [WorkoutResultPayload]) {
    encode(results, key: Keys.unsyncedResults)
  }

  func saveWorkoutPlans(_ plans: [WatchWorkoutPlanSummary]) {
    encode(plans, key: Keys.workoutPlans)
  }

  func loadWorkoutPlans() -> [WatchWorkoutPlanSummary] {
    decode([WatchWorkoutPlanSummary].self, key: Keys.workoutPlans) ?? []
  }

  func saveWorkoutPlanDetails(_ details: [String: WatchWorkoutPlanDetail]) {
    encode(details, key: Keys.workoutPlanDetails)
  }

  func loadWorkoutPlanDetails() -> [String: WatchWorkoutPlanDetail] {
    decode([String: WatchWorkoutPlanDetail].self, key: Keys.workoutPlanDetails) ?? [:]
  }

  func saveRecipes(_ recipes: [WatchRecipeSummary]) {
    encode(recipes, key: Keys.recipes)
  }

  func loadRecipes() -> [WatchRecipeSummary] {
    decode([WatchRecipeSummary].self, key: Keys.recipes) ?? []
  }

  func saveRecipeDetails(_ details: [String: WatchRecipeDetail]) {
    encode(details, key: Keys.recipeDetails)
  }

  func loadRecipeDetails() -> [String: WatchRecipeDetail] {
    decode([String: WatchRecipeDetail].self, key: Keys.recipeDetails) ?? [:]
  }

  func saveCompletionSummaries(_ summaries: [String: WatchWorkoutCompletionSummary]) {
    encode(summaries, key: Keys.completionSummaries)
  }

  func loadCompletionSummaries() -> [String: WatchWorkoutCompletionSummary] {
    decode([String: WatchWorkoutCompletionSummary].self, key: Keys.completionSummaries) ?? [:]
  }

  private func encode<T: Encodable>(_ value: T, key: String) {
    guard let data = try? encoder.encode(value) else { return }
    defaults.set(data, forKey: key)
  }

  private func decode<T: Decodable>(_ type: T.Type, key: String) -> T? {
    guard let data = defaults.data(forKey: key) else { return nil }
    return try? decoder.decode(type, from: data)
  }
}
