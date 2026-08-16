import Combine
import Foundation

final class WorkoutViewModel: ObservableObject {
  @Published private(set) var snapshot: WatchWorkoutSnapshot?
  @Published private(set) var preparedWorkout: ScheduledWatchWorkout?
  @Published private(set) var session: WorkoutSessionState
  @Published private(set) var syncMessage: String?
  @Published private(set) var completionSummary: WatchWorkoutCompletionSummary?
  @Published private(set) var isCompletingWorkout = false
  @Published private(set) var authState: WatchAuthenticationState
  @Published private(set) var isRefreshing = false
  @Published private(set) var workoutPlans: [WatchWorkoutPlanSummary]
  @Published private(set) var selectedWorkoutPlan: WatchWorkoutPlanSummary?
  @Published private(set) var isLoadingWorkoutPlans = false
  @Published private(set) var workoutPlansMessage: String?
  @Published private(set) var workoutPlanDetails: [String: WatchWorkoutPlanDetail]
  @Published private(set) var loadingWorkoutPlanSlug: String?
  @Published private(set) var workoutPlanDetailMessage: String?
  @Published private(set) var previousSetsByExerciseID: [String: PreviousSet] = [:]
  @Published private(set) var isStartingWorkout = false
  @Published private(set) var recipes: [WatchRecipeSummary]
  @Published private(set) var isLoadingRecipes = false
  @Published private(set) var recipesMessage: String?
  @Published private(set) var recipeDetails: [String: WatchRecipeDetail]
  @Published private(set) var loadingRecipeSlug: String?
  @Published private(set) var recipeDetailMessage: String?
  @Published private(set) var completionSummaries: [String: WatchWorkoutCompletionSummary]

  let restTimer = RestTimerService()

  private let store: WatchWorkoutStore
  private let connectivity: PhoneConnectivityService
  private let auth: WatchAuthManager
  private let apiClient: WatchAPIClient
  private var hasSubmittedWorkoutCompletion = false

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
    self.preparedWorkout = nil
    self.session = store.loadSession()
    self.completionSummary = nil
    self.authState = auth.state
    self.workoutPlans = store.loadWorkoutPlans()
    self.selectedWorkoutPlan = nil
    self.workoutPlanDetails = store.loadWorkoutPlanDetails()
    self.recipes = store.loadRecipes()
    self.recipeDetails = store.loadRecipeDetails()
    self.completionSummaries = store.loadCompletionSummaries()

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
    preparedWorkout ?? snapshot?.workout
  }

  var displayedWorkoutSlug: String? {
    if let selectedSlug = selectedWorkoutPlan?.slug,
       !selectedSlug.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      return selectedSlug
    }
    let slug = workout?.plan.slug.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    return slug.isEmpty ? nil : slug
  }

  var displayedWorkoutDetail: WatchWorkoutPlanDetail? {
    displayedWorkoutSlug.flatMap { workoutPlanDetails[$0] }
  }

  var isDisplayedWorkoutCompleted: Bool {
    guard let slug = displayedWorkoutSlug else { return false }
    if completionSummaries[slug] != nil { return true }
    return snapshot?.workout?.plan.slug == slug && snapshot?.workout?.isCompleted == true
  }

  @MainActor
  func prepareCompletedWorkoutForDisplay() {
    guard let slug = displayedWorkoutSlug else { return }
    if let summary = completionSummaries[slug] {
      completionSummary = summary
      return
    }
    completionSummary = nil
  }

  var displayedExercisePreviousSet: PreviousSet? {
    guard let exerciseID = displayedWorkoutDetail?.exercises
      .sorted(by: { $0.order < $1.order })
      .first?.id else { return nil }
    return previousSetsByExerciseID[exerciseID]
  }

  var meals: [WatchMeal] {
    snapshot?.meals ?? []
  }

  var homeMeals: [WatchMeal] {
    meals
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
    let name = (selectedWorkoutPlan?.name ?? workout?.plan.name)?
      .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    return name.isEmpty ? "No Workout" : name
  }

  var homeWorkoutName: String {
    normalized(snapshot?.workout?.plan.name) ?? "No Workout"
  }

  var homeWorkoutCategory: String {
    normalized(snapshot?.workout?.plan.category) ?? "--"
  }

  var homeWorkoutDurationMinutes: Int? {
    snapshot?.workout?.plan.durationMinutes
  }

  var homeWorkoutCalories: Int? {
    snapshot?.workout?.plan.caloriesBurned
  }

  var activeWorkoutName: String {
    sessionScheduledPlan.map(\.name)
      ?? sessionPlanDetail.map(\.name)
      ?? sessionPlanSummary.map(\.name)
      ?? workoutName
  }

  var activeWorkoutCategory: String {
    normalized(sessionScheduledPlan?.category)
      ?? normalized(sessionPlanDetail?.category)
      ?? normalized(sessionPlanSummary?.category)
      ?? workoutCategory
  }

  var activeWorkoutDurationMinutes: Int {
    sessionScheduledPlan?.durationMinutes
      ?? sessionPlanDetail?.durationMinutes
      ?? sessionPlanSummary?.durationMinutes
      ?? durationMinutes
  }

  var activeWorkoutCalories: Int {
    sessionScheduledPlan?.caloriesBurned
      ?? sessionPlanDetail?.caloriesBurned
      ?? sessionPlanSummary?.caloriesBurned
      ?? caloriesBurned
  }

  var workoutCategory: String {
    let category = (selectedWorkoutPlan?.category ?? workout?.plan.category)?
      .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    return category.isEmpty ? "--" : category
  }

  var scheduledTimeText: String {
    if session.status != .idle,
       session.workoutPlanSlug == displayedWorkoutSlug,
       let startedAt = session.startedAt {
      return Self.displayTimeFormatter.string(from: startedAt)
    }
    if let selectedSlug = selectedWorkoutPlan?.slug, workout?.plan.slug != selectedSlug {
      return "--:--"
    }
    guard let scheduledTime = workout?.scheduledTime, !scheduledTime.isEmpty else {
      return "--:--"
    }
    if let date = Self.apiTimestampFormatter.date(from: scheduledTime)
      ?? Self.apiTimestampWithoutFractionsFormatter.date(from: scheduledTime) {
      return Self.displayTimeFormatter.string(from: date)
    }
    if let date = Self.apiClockFormatter.date(from: scheduledTime) {
      return Self.displayTimeFormatter.string(from: date)
    }
    return scheduledTime
  }

  var displayedWorkoutStartLabel: String {
    if selectedWorkoutPlan != nil {
      guard session.status != .idle,
            session.workoutPlanSlug == displayedWorkoutSlug,
            let startedAt = session.startedAt else {
        return "NOT STARTED"
      }
      return "STARTED AT \(Self.displayTimeFormatter.string(from: startedAt))"
    }
    return "STARTS AT \(scheduledTimeText)"
  }

  var durationMinutes: Int {
    selectedWorkoutPlan?.durationMinutes
      ?? workout?.plan.durationMinutes
      ?? 0
  }

  var caloriesBurned: Int {
    selectedWorkoutPlan?.caloriesBurned
      ?? workout?.plan.caloriesBurned
      ?? 0
  }

  var mealCalories: Int? {
    if let total = snapshot?.summary?.mealsCalories {
      return total
    }
    let values = homeMeals.compactMap(\.calories)
    return values.isEmpty ? nil : values.reduce(0, +)
  }

  var homeSessionsCount: Int? {
    snapshot?.summary?.sessionsCount
  }

  var homeSessionsDurationMinutes: Int? {
    snapshot?.summary?.sessionsDurationMinutes
  }

  var homeMealsCount: Int? {
    snapshot?.summary?.mealsCount ?? (homeMeals.isEmpty ? nil : homeMeals.count)
  }

  var activeCalories: Int {
    activeWorkoutCalories
  }

  var averageHeartRate: Int? {
    completionSummary?.averageHeartRate
  }

  var workoutGoalProgress: Double? {
    completionSummary?.goalProgress
  }

  var completedDurationMinutes: Int {
    completionSummary?.actualDurationMinutes
      ?? max(activeElapsedSeconds(at: session.finishedAt ?? Date()) / 60, 1)
  }

  var completedCalories: Int? {
    completionSummary?.calories
  }

  var completedVolume: Double {
    session.completedSets.reduce(0) { total, set in
      total + ((set.weight ?? 0) * Double(max(set.reps, 0)))
    }
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

  @MainActor
  func loadWorkoutPlans(forceRefresh: Bool = false) async {
    guard !isLoadingWorkoutPlans else { return }
    if !forceRefresh, !workoutPlans.isEmpty { return }

    isLoadingWorkoutPlans = true
    workoutPlansMessage = nil
    defer { isLoadingWorkoutPlans = false }

    do {
      let plans = try await apiClient.fetchWorkoutPlans()
      workoutPlans = plans
      store.saveWorkoutPlans(plans)
      workoutPlansMessage = plans.isEmpty ? "No workout sessions available" : nil
    } catch {
      workoutPlansMessage = error.localizedDescription
    }
  }

  @MainActor
  func loadDisplayedWorkoutDetail(forceRefresh: Bool = false) async {
    guard let slug = displayedWorkoutSlug else { return }
    guard loadingWorkoutPlanSlug == nil else { return }
    if !forceRefresh, workoutPlanDetails[slug] != nil { return }

    loadingWorkoutPlanSlug = slug
    workoutPlanDetailMessage = nil
    defer { loadingWorkoutPlanSlug = nil }

    do {
      let detail = try await apiClient.fetchWorkoutPlan(slug: slug)
      workoutPlanDetails[slug] = detail
      store.saveWorkoutPlanDetails(workoutPlanDetails)
    } catch {
      workoutPlanDetailMessage = error.localizedDescription
    }
  }

  func selectWorkoutPlan(_ plan: WatchWorkoutPlanSummary) {
    selectedWorkoutPlan = plan
    workoutPlanDetailMessage = nil
  }

  func selectTodayWorkout() {
    selectedWorkoutPlan = nil
    preparedWorkout = nil
    workoutPlanDetailMessage = nil
  }

  @MainActor
  func loadDisplayedExerciseHistory(forceRefresh: Bool = false) async {
    guard let exerciseID = displayedWorkoutDetail?.exercises
      .sorted(by: { $0.order < $1.order })
      .first?.id else { return }
    if !forceRefresh, previousSetsByExerciseID[exerciseID] != nil { return }

    do {
      if let previousSet = try await apiClient.fetchLatestExerciseResult(exerciseID: exerciseID) {
        previousSetsByExerciseID[exerciseID] = previousSet
      }
    } catch {
      workoutPlanDetailMessage = error.localizedDescription
    }
  }

  @MainActor
  func loadRecipes(forceRefresh: Bool = false) async {
    guard !isLoadingRecipes else { return }
    if !forceRefresh, !recipes.isEmpty { return }

    isLoadingRecipes = true
    recipesMessage = nil
    defer { isLoadingRecipes = false }

    do {
      let loadedRecipes = try await apiClient.fetchRecipes()
      recipes = loadedRecipes
      store.saveRecipes(loadedRecipes)
      recipesMessage = loadedRecipes.isEmpty ? "No meals available" : nil
    } catch {
      recipesMessage = error.localizedDescription
    }
  }

  @MainActor
  func loadRecipeDetail(slug: String, forceRefresh: Bool = false) async {
    guard loadingRecipeSlug == nil else { return }
    if !forceRefresh, recipeDetails[slug] != nil { return }

    loadingRecipeSlug = slug
    recipeDetailMessage = nil
    defer { loadingRecipeSlug = nil }

    do {
      let detail = try await apiClient.fetchRecipe(slug: slug)
      recipeDetails[slug] = detail
      store.saveRecipeDetails(recipeDetails)
    } catch {
      recipeDetailMessage = error.localizedDescription
    }
  }


  func startWorkout(at startedAt: Date) {
    guard workout != nil else { return }
    session.status = .active
    session.currentExerciseIndex = 0
    session.currentSetIndex = 0
    session.workoutPlanSlug = workout?.plan.slug
    session.startedAt = startedAt
    session.pausedAt = nil
    session.accumulatedPausedDuration = 0
    session.finishedAt = nil
    session.completedSets = []
    completionSummary = nil
    hasSubmittedWorkoutCompletion = false
    persistSession()
  }

  @MainActor
  func startWorkoutFromAPI() async {
    guard !isStartingWorkout else { return }
    if session.status == .active || session.status == .paused {
      if session.workoutPlanSlug == displayedWorkoutSlug {
        return
      }
      resetWorkout()
    }
    guard session.status == .idle || session.status == .finished else { return }
    if displayedWorkoutDetail == nil {
      await loadDisplayedWorkoutDetail()
    }
    prepareDisplayedWorkoutIfNeeded()
    guard let exercise = currentExercise else {
      syncMessage = "No exercise available"
      return
    }

    isStartingWorkout = true
    defer { isStartingWorkout = false }

    do {
      let createdWorkout = try await apiClient.createWorkoutLog(
        exerciseID: exercise.exerciseId,
        value: exercise.reps,
        workoutDate: Self.apiDateFormatter.string(from: Date())
      )
      guard let id = createdWorkout.id, let startedAt = createdWorkout.startedAt else {
        syncMessage = "Start response is missing session data"
        return
      }
      updateStartedWorkout(id: id, startedAt: startedAt)
      startWorkout(at: startedAt)
      syncMessage = "Workout started"
    } catch {
      syncMessage = "Could not start workout"
    }
  }

  func prepareDisplayedWorkoutIfNeeded() {
    guard let detail = displayedWorkoutDetail else { return }
    if workout?.plan.slug == detail.slug { return }

    let mappedExercises = detail.exercises
      .sorted(by: { $0.order < $1.order })
      .enumerated()
      .compactMap { index, exercise -> WatchExercise? in
        guard let sets = exercise.sets,
              let reps = exercise.reps,
              let restSeconds = exercise.restSeconds else { return nil }
        return WatchExercise(
          id: index + 1,
          exerciseId: exercise.id,
          name: exercise.name,
          sets: sets,
          reps: reps,
          weight: exercise.weight,
          previousSet: previousSetsByExerciseID[exercise.id],
          restSeconds: restSeconds,
          order: exercise.order,
          unit: exercise.unit,
          category: exercise.category
        )
      }

    let preparedWorkout = ScheduledWatchWorkout(
      scheduledWorkoutId: 0,
      scheduledTime: "",
      isCompleted: false,
      plan: WatchWorkoutPlan(
        id: detail.id,
        name: detail.name,
        slug: detail.slug,
        difficulty: detail.difficulty,
        category: detail.category,
        durationMinutes: detail.durationMinutes,
        caloriesBurned: detail.caloriesBurned,
        exercises: mappedExercises
      )
    )

    self.preparedWorkout = preparedWorkout
    resetWorkout()
  }

  func pauseWorkout() {
    guard session.status == .active || session.status == .resting else { return }
    restTimer.stop()
    session.status = .paused
    session.pausedAt = Date()
    persistSession()
  }

  func resumeWorkout() {
    guard session.status == .paused else { return }
    if let pausedAt = session.pausedAt {
      session.accumulatedPausedDuration += max(Date().timeIntervalSince(pausedAt), 0)
    }
    session.pausedAt = nil
    session.status = .active
    persistSession()
  }

  func activeElapsedSeconds(at date: Date = Date()) -> Int {
    guard let startedAt = session.startedAt else { return 0 }
    let effectiveEnd = session.finishedAt ?? session.pausedAt ?? date
    let elapsed = effectiveEnd.timeIntervalSince(startedAt) - session.accumulatedPausedDuration
    return max(Int(elapsed), 0)
  }

  func remainingWorkoutSeconds(at date: Date = Date()) -> Int {
    max(activeWorkoutDurationMinutes * 60 - activeElapsedSeconds(at: date), 0)
  }

  func workoutTimeProgress(at date: Date = Date()) -> Double {
    let total = activeWorkoutDurationMinutes * 60
    guard total > 0 else { return 0 }
    return min(max(Double(activeElapsedSeconds(at: date)) / Double(total), 0), 1)
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
    guard workout != nil, session.status != .finished else { return }
    restTimer.stop()
    if let pausedAt = session.pausedAt {
      session.accumulatedPausedDuration += max(Date().timeIntervalSince(pausedAt), 0)
      session.pausedAt = nil
    }
    session.status = .finished
    session.finishedAt = Date()
    persistSession()
  }

  @MainActor
  func submitFinishedWorkout() async {
    guard session.status == .finished,
          let workout,
          !isCompletingWorkout,
          !hasSubmittedWorkoutCompletion else { return }

    let result = WorkoutResultPayload(
      resultId: UUID(),
      scheduledWorkoutId: workout.scheduledWorkoutId,
      workoutPlanId: workout.plan.id,
      finishedAt: session.finishedAt ?? Date(),
      completedSets: session.completedSets
    )

    isCompletingWorkout = true
    defer { isCompletingWorkout = false }

    guard result.scheduledWorkoutId > 0 else {
      queueResultThroughPhone(result)
      syncMessage = "Saved for later sync"
      hasSubmittedWorkoutCompletion = true
      return
    }

    let durationMinutes = max(activeElapsedSeconds(at: session.finishedAt ?? Date()) / 60, 1)
    do {
      completionSummary = try await apiClient.completeWorkout(
        id: result.scheduledWorkoutId,
        actualDuration: durationMinutes
      )
      saveCompletedWorkoutSummary()
      syncMessage = completionSummary?.hasStatistics == true
        ? "Workout synced"
        : "Workout saved; statistics unavailable"
    } catch {
      syncMessage = "Saved for later sync"
      queueResultThroughPhone(result)
    }
    hasSubmittedWorkoutCompletion = true
  }

  private func saveCompletedWorkoutSummary() {
    guard let slug = session.workoutPlanSlug, let summary = completionSummary else { return }
    completionSummaries[slug] = summary
    store.saveCompletionSummaries(completionSummaries)
    markCurrentWorkoutCompleted(slug: slug)
  }

  private func markCurrentWorkoutCompleted(slug: String) {
    if let currentWorkout = preparedWorkout, currentWorkout.plan.slug == slug {
      preparedWorkout = ScheduledWatchWorkout(
        scheduledWorkoutId: currentWorkout.scheduledWorkoutId,
        scheduledTime: currentWorkout.scheduledTime,
        isCompleted: true,
        plan: currentWorkout.plan
      )
    }
    guard let currentSnapshot = snapshot,
          let currentWorkout = currentSnapshot.workout,
          currentWorkout.plan.slug == slug else { return }
    receive(WatchWorkoutSnapshot(
      schemaVersion: currentSnapshot.schemaVersion,
      generatedAt: currentSnapshot.generatedAt,
      date: currentSnapshot.date,
      summary: currentSnapshot.summary,
      workout: ScheduledWatchWorkout(
        scheduledWorkoutId: currentWorkout.scheduledWorkoutId,
        scheduledTime: currentWorkout.scheduledTime,
        isCompleted: true,
        plan: currentWorkout.plan
      ),
      meals: currentSnapshot.meals
    ))
  }

  func resetWorkout() {
    restTimer.stop()
    session = .empty
    completionSummary = nil
    hasSubmittedWorkoutCompletion = false
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
    preparedWorkout = nil
    session = .empty
    completionSummary = nil
    hasSubmittedWorkoutCompletion = false
    authState = .requiresPhone
    syncMessage = "Sign in on your iPhone to continue"
  }

  private func retryQueuedResults() {
    let unsynced = store.loadUnsyncedResults()
    guard !unsynced.isEmpty else { return }
    let remaining = connectivity.retryQueuedResults(unsynced)
    store.replaceUnsyncedResults(remaining)
  }

  private func queueResultThroughPhone(_ result: WorkoutResultPayload) {
    if !connectivity.sendWorkoutResult(result) {
      store.appendUnsyncedResult(result)
    }
  }

  private func persistSession() {
    store.saveSession(session)
  }

  private var sessionScheduledPlan: WatchWorkoutPlan? {
    guard let slug = session.workoutPlanSlug,
          workout?.plan.slug == slug else { return nil }
    return workout?.plan
  }

  private var sessionPlanDetail: WatchWorkoutPlanDetail? {
    guard let slug = session.workoutPlanSlug else { return nil }
    return workoutPlanDetails[slug]
  }

  private var sessionPlanSummary: WatchWorkoutPlanSummary? {
    guard let slug = session.workoutPlanSlug else { return nil }
    return workoutPlans.first(where: { $0.slug == slug })
  }

  private func normalized(_ value: String?) -> String? {
    let text = value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    return text.isEmpty ? nil : text
  }

  private func updateStartedWorkout(id: Int, startedAt: Date) {
    if let currentWorkout = preparedWorkout {
      preparedWorkout = ScheduledWatchWorkout(
        scheduledWorkoutId: id,
        scheduledTime: Self.apiTimestampFormatter.string(from: startedAt),
        isCompleted: currentWorkout.isCompleted,
        plan: currentWorkout.plan
      )
      return
    }

    guard let currentSnapshot = snapshot, let currentWorkout = currentSnapshot.workout else { return }
    receive(
      WatchWorkoutSnapshot(
        schemaVersion: currentSnapshot.schemaVersion,
        generatedAt: currentSnapshot.generatedAt,
        date: currentSnapshot.date,
        summary: currentSnapshot.summary,
        workout: ScheduledWatchWorkout(
          scheduledWorkoutId: id,
          scheduledTime: Self.apiTimestampFormatter.string(from: startedAt),
          isCompleted: currentWorkout.isCompleted,
          plan: currentWorkout.plan
        ),
        meals: currentSnapshot.meals
      )
    )
  }

  private static let apiDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  private static let displayTimeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "h:mm a"
    return formatter
  }()

  private static let apiClockFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "HH:mm:ss"
    return formatter
  }()

  private static let apiTimestampFormatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter
  }()

  private static let apiTimestampWithoutFractionsFormatter = ISO8601DateFormatter()
}
