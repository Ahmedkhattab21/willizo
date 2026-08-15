import Combine
import Foundation

final class WorkoutViewModel: ObservableObject {
  @Published private(set) var snapshot: WatchWorkoutSnapshot?
  @Published private(set) var session: WorkoutSessionState
  @Published private(set) var syncMessage: String?
  @Published private(set) var authState: WatchAuthenticationState
  @Published private(set) var isRefreshing = false

  let restTimer = RestTimerService()

  private let store: WatchWorkoutStore
  private let connectivity: PhoneConnectivityService
  private let auth: WatchAuthManager
  private let apiClient: WatchAPIClient

  init(
    store: WatchWorkoutStore = WatchWorkoutStore(),
    connectivity: PhoneConnectivityService = PhoneConnectivityService(),
    auth: WatchAuthManager = WatchAuthManager()
  ) {
    self.store = store
    self.connectivity = connectivity
    self.auth = auth
    self.apiClient = WatchAPIClient(auth: auth, connectivity: connectivity)
    self.snapshot = store.loadSnapshot()
    self.session = store.loadSession()
    self.authState = auth.state

    connectivity.onWorkoutSnapshotReceived = { [weak self] snapshot in
      self?.receive(snapshot)
    }
    connectivity.onAuthSessionReceived = { [weak self] payload in
      guard let self, self.auth.accept(payload) else { return }
      self.authState = .authenticated
      self.loadDirectWorkoutData()
    }
    connectivity.onAuthCleared = { [weak self] in
      self?.clearPrivateData()
    }
    connectivity.$lastSyncMessage.assign(to: &$syncMessage)
    retryQueuedResults()
    requestLatestWorkout()
  }

  var workout: ScheduledWatchWorkout? {
    snapshot?.workout
  }

  var meals: [WatchMeal] {
    snapshot?.meals ?? []
  }

  var exercises: [WatchExercise] {
    workout?.plan.exercises.sorted(by: { $0.order < $1.order }) ?? []
  }

  var currentExercise: WatchExercise? {
    guard exercises.indices.contains(session.currentExerciseIndex) else { return nil }
    return exercises[session.currentExerciseIndex]
  }

  var nextExercise: WatchExercise? {
    let nextIndex = session.currentExerciseIndex + 1
    guard exercises.indices.contains(nextIndex) else { return nil }
    return exercises[nextIndex]
  }

  var currentSetNumber: Int {
    session.currentSetIndex + 1
  }

  var progressText: String {
    guard !exercises.isEmpty else { return "0%" }
    let totalSets = exercises.reduce(0) { $0 + $1.safeSetCount }
    guard totalSets > 0 else { return "0%" }
    let percent = Int((Double(session.completedSets.count) / Double(totalSets)) * 100)
    return "\(min(percent, 100))%"
  }

  var progressValue: Double {
    guard !exercises.isEmpty else { return 0 }
    let totalSets = exercises.reduce(0) { $0 + $1.safeSetCount }
    guard totalSets > 0 else { return 0 }
    return min(Double(session.completedSets.count) / Double(totalSets), 1)
  }

  var workoutName: String {
    let name = workout?.plan.name.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    return name.isEmpty ? "No Workout" : name
  }

  var workoutCategory: String {
    let category = workout?.plan.category?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    return category.isEmpty ? "Workout" : category
  }

  var scheduledTimeText: String {
    guard let scheduledTime = workout?.scheduledTime, !scheduledTime.isEmpty else {
      return "--:--"
    }
    return String(scheduledTime.prefix(5))
  }

  var durationMinutes: Int {
    workout?.plan.durationMinutes ?? 0
  }

  var caloriesBurned: Int {
    workout?.plan.caloriesBurned ?? 0
  }

  var mealCalories: Int {
    meals.compactMap(\.calories).reduce(0, +)
  }

  var activeCalories: Int {
    max(Int(Double(caloriesBurned) * max(progressValue, 0.75)), 0)
  }

  var averageHeartRate: Int {
    142
  }

  var workoutGoalProgress: Double {
    if session.status == .finished {
      return max(progressValue, 0.75)
    }
    return progressValue
  }

  func requestLatestWorkout() {
    guard auth.session != nil else {
      authState = .connecting
      connectivity.requestAuthSession()
      return
    }
    loadDirectWorkoutData()
  }

  @MainActor
  func refreshHomeData() async {
    guard !isRefreshing else { return }
    guard auth.session != nil else {
      connectivity.requestAuthSession()
      return
    }
    isRefreshing = true
    defer { isRefreshing = false }

    do {
      try await apiClient.fetchProfile()
      let snapshot = try await apiClient.fetchHomeSnapshot()
      receive(snapshot)
      authState = .authenticated
      syncMessage = "Home updated"
    } catch {
      if auth.session == nil {
        authState = .requiresPhone
        connectivity.requestAuthSession()
      }
      syncMessage = error.localizedDescription
    }
  }

  func startWorkout() {
    guard workout != nil else { return }
    session.status = .active
    session.startedAt = session.startedAt ?? Date()
    persistSession()
  }

  func pauseWorkout() {
    guard session.status == .active || session.status == .resting else { return }
    restTimer.stop()
    session.status = .paused
    persistSession()
  }

  func resumeWorkout() {
    guard session.status == .paused else { return }
    session.status = .active
    persistSession()
  }

  func completeCurrentSet() {
    guard session.status == .active, let exercise = currentExercise else { return }

    let completedSet = CompletedWorkoutSet(
      id: UUID(),
      exerciseId: exercise.exerciseId,
      exerciseName: exercise.name,
      setNumber: currentSetNumber,
      reps: exercise.reps,
      weight: exercise.weight,
      completedAt: Date()
    )
    session.completedSets.append(completedSet)

    if session.currentSetIndex + 1 < exercise.safeSetCount {
      beginRest(afterLastSetOfExercise: false)
    } else if nextExercise != nil {
      beginRest(afterLastSetOfExercise: true)
    } else {
      finishWorkout()
    }

    persistSession()
  }

  func finishWorkout() {
    guard let workout else { return }
    restTimer.stop()
    session.status = .finished
    session.finishedAt = Date()
    persistSession()

    let result = WorkoutResultPayload(
      resultId: UUID(),
      scheduledWorkoutId: workout.scheduledWorkoutId,
      workoutPlanId: workout.plan.id,
      finishedAt: session.finishedAt ?? Date(),
      completedSets: session.completedSets
    )

    syncFinishedWorkout(result)
  }

  func resetWorkout() {
    restTimer.stop()
    session = .empty
    store.clearSession()
  }

  private func beginRest(afterLastSetOfExercise: Bool) {
    guard let exercise = currentExercise else { return }
    session.status = .resting
    persistSession()

    restTimer.start(seconds: exercise.safeRestSeconds) { [weak self] in
      self?.advance(afterLastSetOfExercise: afterLastSetOfExercise)
    }
  }

  func skipRest() {
    restTimer.skip()
  }

  private func advance(afterLastSetOfExercise: Bool) {
    if afterLastSetOfExercise {
      session.currentExerciseIndex += 1
      session.currentSetIndex = 0
    } else {
      session.currentSetIndex += 1
    }
    session.status = .active
    persistSession()
  }

  private func receive(_ snapshot: WatchWorkoutSnapshot) {
    self.snapshot = snapshot
    store.saveSnapshot(snapshot)
  }

  private func loadDirectWorkoutData() {
    Task { [weak self] in
      await self?.refreshHomeData()
    }
  }

  private func clearPrivateData() {
    restTimer.stop()
    auth.clear()
    store.clearPrivateData()
    snapshot = nil
    session = .empty
    authState = .requiresPhone
    syncMessage = "Sign in on your iPhone to continue"
  }

  private func retryQueuedResults() {
    let unsynced = store.loadUnsyncedResults()
    guard !unsynced.isEmpty else { return }
    let remaining = connectivity.retryQueuedResults(unsynced)
    store.replaceUnsyncedResults(remaining)
  }

  private func syncFinishedWorkout(_ result: WorkoutResultPayload) {
    guard result.scheduledWorkoutId > 0 else {
      queueResultThroughPhone(result)
      return
    }
    let elapsed = max((session.finishedAt ?? Date()).timeIntervalSince(session.startedAt ?? Date()), 0)
    let durationMinutes = max(Int(elapsed / 60), 1)
    Task { [weak self] in
      guard let self else { return }
      do {
        try await self.apiClient.completeWorkout(
          id: result.scheduledWorkoutId,
          actualDuration: durationMinutes
        )
        await MainActor.run {
          self.syncMessage = "Workout synced"
        }
      } catch {
        await MainActor.run {
          self.syncMessage = "Saved for later sync"
          self.queueResultThroughPhone(result)
        }
      }
    }
  }

  private func queueResultThroughPhone(_ result: WorkoutResultPayload) {
    if !connectivity.sendWorkoutResult(result) {
      store.appendUnsyncedResult(result)
    }
  }

  private func persistSession() {
    store.saveSession(session)
  }
}
