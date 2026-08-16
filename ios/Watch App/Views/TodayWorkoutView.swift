import SwiftUI

struct TodayWorkoutView: View {
  @ObservedObject var viewModel: WorkoutViewModel
  @State private var isAtTop = true

  var body: some View {
    ScrollView {
      VStack(spacing: 0) {
        GeometryReader { proxy in
          Color.clear.preference(
            key: HomeScrollOffsetKey.self,
            value: proxy.frame(in: .named("homeScroll")).minY
          )
        }
        .frame(height: 0)

        DesignCanvas(height: 382, referenceWidth: 176) {
          FigmaHomeView(viewModel: viewModel)
        }
      }
    }
    .coordinateSpace(name: "homeScroll")
    .onPreferenceChange(HomeScrollOffsetKey.self) { offset in
      isAtTop = offset >= -2
    }
    .simultaneousGesture(
      DragGesture(minimumDistance: 18)
        .onEnded { value in
          let isDownwardPull = value.translation.height >= 32
            && abs(value.translation.height) > abs(value.translation.width)
          guard isAtTop, isDownwardPull else { return }
          Task {
            await refreshAllData()
          }
        }
    )
    .background(WatchTheme.background.ignoresSafeArea())
    .dynamicTypeSize(.xSmall ... .medium)
    .ignoresSafeArea()
    .task {
      await viewModel.loadWorkoutPlans()
      await viewModel.loadRecipes()
    }
    .refreshable {
      await refreshAllData()
    }
    .overlay(alignment: .topLeading) {
      Button {
        Task { await refreshAllData() }
      } label: {
        if viewModel.isRefreshing || viewModel.isLoadingWorkoutPlans {
          ProgressView()
            .controlSize(.mini)
            .tint(WatchTheme.lime)
        } else {
          Image(systemName: "arrow.clockwise")
            .font(.system(size: 8, weight: .semibold))
            .foregroundStyle(WatchTheme.lime)
        }
      }
      .buttonStyle(.plain)
      .frame(width: 24, height: 24)
      .padding(.leading, 5)
      .padding(.top, 17)
      .disabled(viewModel.isRefreshing || viewModel.isLoadingWorkoutPlans)
      .accessibilityLabel("Refresh home data")
    }
    .overlay(alignment: .top) {
      if viewModel.isRefreshing || viewModel.isLoadingWorkoutPlans {
        ProgressView()
          .controlSize(.mini)
          .tint(WatchTheme.lime)
          .padding(.top, 20)
          .transition(.opacity)
          .accessibilityLabel("Refreshing home data")
      }
    }
    .animation(.easeInOut(duration: 0.15), value: viewModel.isRefreshing)
  }

  private func refreshAllData() async {
    await viewModel.refreshHomeData()
    await viewModel.loadWorkoutPlans(forceRefresh: true)
    await viewModel.loadRecipes(forceRefresh: true)
  }

  private var quickCards: some View {
    HStack(spacing: 10) {
      MiniSummaryCard(
        icon: "dumbbell.fill",
        title: "Gym",
        subtitle: "\(shortCategory(viewModel.homeWorkoutCategory)) • \(minutesText(viewModel.homeWorkoutDurationMinutes))",
        tint: WatchTheme.lime
      )
      MiniSummaryCard(
        icon: "fork.knife",
        title: "Meals",
        subtitle: "\(countText(viewModel.homeMealsCount, unit: "meals")) • \(caloriesText(viewModel.mealCalories))",
        tint: WatchTheme.lime
      )
    }
  }

  private func shortCategory(_ category: String) -> String {
    if category.localizedCaseInsensitiveContains("strength") {
      return "Strength"
    }
    return category.capitalized
  }

  private var todayWorkoutCard: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("Today's Workout")
        .font(.system(size: 7, weight: .bold))

      WatchCard {
        VStack(alignment: .leading, spacing: 10) {
          HStack {
            NeonIcon(symbol: "dumbbell.fill", size: 24)
            Text(viewModel.homeWorkoutName)
              .font(.system(size: 9, weight: .bold))
              .fontWeight(.bold)
              .lineLimit(2)
            Spacer()
            Text("Today")
              .font(.system(size: 9, weight: .bold))
              .fontWeight(.bold)
              .foregroundStyle(WatchTheme.lime)
          }

          HStack(spacing: 10) {
            TileMetric(icon: "timer", title: "Duration", value: minutesText(viewModel.homeWorkoutDurationMinutes), tint: WatchTheme.lime)
            TileMetric(icon: "flame.fill", title: "Cal", value: numberText(viewModel.homeWorkoutCalories), tint: .orange)
          }

          NavigationLink {
            WorkoutLandingView(viewModel: viewModel)
          } label: {
            Label("Start", systemImage: "play.fill")
              .font(.system(size: 7, weight: .bold))
              .frame(maxWidth: .infinity)
          }
          .buttonStyle(NeonButtonStyle(compact: true))
        }
      }
    }
  }

  private var fuelCard: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("Today's Fuel")
        .font(.system(size: 7, weight: .bold))

      WatchCard {
        VStack(alignment: .leading, spacing: 10) {
          HStack(spacing: 10) {
            Circle()
              .fill(.orange)
              .frame(width: 24, height: 24)
              .overlay(Image(systemName: "fork.knife").foregroundStyle(.black))
            VStack(alignment: .leading, spacing: 2) {
              Text("Meal Plan")
                .font(.system(size: 8, weight: .bold))
              Text(kcalText(viewModel.mealCalories))
                .font(.caption2)
                .foregroundStyle(.secondary)
            }
          }

          ForEach(Array(viewModel.homeMeals.prefix(3).enumerated()), id: \.element.id) { _, meal in
            MealRow(time: meal.scheduledTime ?? meal.mealType.capitalized, meal: meal)
          }
        }
      }
    }
  }

  @ViewBuilder
  private var syncFooter: some View {
    if let syncMessage = viewModel.syncMessage {
      Text(syncMessage)
        .font(.caption2)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
        .lineLimit(2)
    }
  }
}

private struct HomeScrollOffsetKey: PreferenceKey {
  static var defaultValue: CGFloat = 0

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

private struct FigmaHomeView: View {
  @ObservedObject var viewModel: WorkoutViewModel
  @State private var currentDate = Date()
  private let systemClockInset: CGFloat = 20
  private let clockTicker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  private var displayMeals: [WatchMeal] {
    viewModel.homeMeals
  }

  var body: some View {
    ZStack(alignment: .topLeading) {
      RoundedRectangle(cornerRadius: 20, style: .continuous)
        .fill(WatchTheme.background)
        .frame(width: 184, height: 382)

      VStack(spacing: 0) {
        Text(HomeHeader.timeFormatter.string(from: currentDate))
          .font(.system(size: 25, weight: .bold, design: .rounded))
          .monospacedDigit()
          .foregroundStyle(.white)
        Text(HomeHeader.dateFormatter.string(from: currentDate))
          .font(.system(size: 6, weight: .regular))
          .foregroundStyle(WatchTheme.muted)
          .padding(.top, 5)
      }
      .frame(width: 184)
      .position(x: 92, y: 35 + systemClockInset)

      NavigationLink {
        WorkoutSessionsView(viewModel: viewModel)
      } label: {
        topTile(
          x: 8,
          icon: "dumbbell",
          title: "Sessions",
          subtitle: countText(viewModel.homeSessionsCount, unit: "sessions"),
          detail: minutesText(viewModel.homeSessionsDurationMinutes),
          rotatesIcon: true
        )
      }
      .buttonStyle(.plain)
      NavigationLink {
        TodayMealsView(viewModel: viewModel)
      } label: {
        topTile(
          x: 96,
          icon: "fork.knife.circle",
          title: "Meal Plan",
          subtitle: countText(viewModel.homeMealsCount, unit: "meals"),
          detail: caloriesText(viewModel.mealCalories)
        )
      }
      .buttonStyle(.plain)

      Text("Today's Workout")
        .font(.system(size: 7, weight: .bold))
        .foregroundStyle(.white)
        .position(x: 39, y: 108 + systemClockInset)

      workoutCard
        .position(x: 92, y: 162 + systemClockInset)

      Text("Today's Fuel")
        .font(.system(size: 7, weight: .bold))
        .foregroundStyle(.white)
        .position(x: 32, y: 219 + systemClockInset)

      fuelCard
        .position(x: 92, y: 290 + systemClockInset)
    }
    .frame(width: 184, height: 382, alignment: .topLeading)
    .onReceive(clockTicker) { date in
      let calendar = Calendar.current
      guard !calendar.isDate(date, equalTo: currentDate, toGranularity: .minute) else { return }
      currentDate = date
    }
  }

  private func topTile(
    x: CGFloat,
    icon: String,
    title: String,
    subtitle: String,
    detail: String,
    rotatesIcon: Bool = false
  ) -> some View {
    ZStack(alignment: .topLeading) {
      RoundedRectangle(cornerRadius: 8, style: .continuous)
        .fill(Color(red: 26 / 255, green: 26 / 255, blue: 29 / 255))

      Image(systemName: icon)
        .font(.system(size: 9, weight: .bold))
        .foregroundStyle(WatchTheme.lime)
        .rotationEffect(rotatesIcon ? .degrees(-45) : .zero)
        .frame(width: 10, height: 10)
        .position(x: 12, y: 12)

      Text(title)
        .font(.system(size: 7, weight: .regular))
        .foregroundStyle(.white)
        .lineLimit(1)
        .frame(width: 56, alignment: .leading)
        .position(x: 50, y: 12)

      (Text(subtitle).foregroundColor(.white)
        + Text(" • ").foregroundColor(WatchTheme.lime)
        + Text(detail).foregroundColor(WatchTheme.lime))
        .font(.system(size: 4.6, weight: .medium))
        .lineLimit(1)
        .minimumScaleFactor(0.7)
        .frame(width: 56, alignment: .leading)
        .position(x: 50, y: 23)
    }
    .frame(width: 80, height: 34)
    .position(x: x + 40, y: 80 + systemClockInset)
  }

  private var workoutCard: some View {
    ZStack(alignment: .topLeading) {
      RoundedRectangle(cornerRadius: 8, style: .continuous)
        .fill(Color(red: 26 / 255, green: 26 / 255, blue: 29 / 255))
        .overlay(
          RoundedRectangle(cornerRadius: 8, style: .continuous)
            .stroke(Color(red: 38 / 255, green: 38 / 255, blue: 38 / 255), lineWidth: 1)
        )

      Circle()
        .fill(Color(red: 170 / 255, green: 1, blue: 0))
        .frame(width: 16, height: 16)
        .overlay(
          Image(systemName: "dumbbell")
            .font(.system(size: 8, weight: .bold))
            .foregroundStyle(.black)
            .rotationEffect(.degrees(-45))
        )
        .position(x: 16, y: 16)

      Text(viewModel.homeWorkoutName)
        .font(.system(size: 6.5, weight: .semibold))
        .foregroundStyle(.white)
        .lineLimit(1)
        .minimumScaleFactor(0.7)
        .frame(width: 96, alignment: .leading)
        .position(x: 78, y: 16)

      Text("Today")
        .font(.system(size: 6.5, weight: .medium))
        .foregroundStyle(Color(red: 170 / 255, green: 1, blue: 0))
        .position(x: 150, y: 16)

      smallMetric(x: 8, icon: "timer", title: "Duration", value: minutesText(viewModel.homeWorkoutDurationMinutes), tint: Color(red: 212 / 255, green: 1, blue: 0))
      smallMetric(x: 88, icon: "flame.fill", title: "Cal", value: numberText(viewModel.homeWorkoutCalories), tint: Color(red: 1, green: 105 / 255, blue: 20 / 255))

      NavigationLink {
        WorkoutLandingView(viewModel: viewModel)
      } label: {
        Label("Start", systemImage: "play.fill")
          .font(.system(size: 7, weight: .bold))
          .foregroundStyle(Color(red: 170 / 255, green: 1, blue: 0))
          .frame(width: 152, height: 16)
          .background(
            Color(red: 44 / 255, green: 52 / 255, blue: 27 / 255),
            in: RoundedRectangle(cornerRadius: 4, style: .continuous)
          )
      }
      .buttonStyle(.plain)
      .position(x: 84, y: 72)
    }
    .frame(width: 168, height: 87)
  }

  private func smallMetric(x: CGFloat, icon: String, title: String, value: String, tint: Color) -> some View {
    ZStack(alignment: .topLeading) {
      RoundedRectangle(cornerRadius: 4, style: .continuous)
        .fill(Color(red: 34 / 255, green: 34 / 255, blue: 34 / 255))

      Image(systemName: icon)
        .font(.system(size: 5.5, weight: .semibold))
        .foregroundStyle(tint)
        .frame(width: 7, height: 7)
        .position(x: 7, y: 8)

      Text(title)
        .font(.system(size: 4.5, weight: .regular))
        .foregroundStyle(tint)
        .frame(width: 54, alignment: .leading)
        .position(x: 41, y: 8)

      Text(value)
        .font(.system(size: 9, weight: .bold))
        .foregroundStyle(.white)
        .lineLimit(1)
        .frame(width: 64, alignment: .leading)
        .position(x: 36, y: 20)
    }
    .frame(width: 72, height: 28)
    .position(x: x + 36, y: 44)
  }

  private var fuelCard: some View {
    ZStack(alignment: .topLeading) {
      RoundedRectangle(cornerRadius: 8, style: .continuous)
        .fill(Color(red: 26 / 255, green: 26 / 255, blue: 29 / 255))
        .overlay(
          RoundedRectangle(cornerRadius: 8, style: .continuous)
            .stroke(Color(red: 38 / 255, green: 38 / 255, blue: 38 / 255), lineWidth: 1)
        )

      Circle()
        .fill(Color(red: 249 / 255, green: 115 / 255, blue: 22 / 255))
        .frame(width: 16, height: 16)
        .overlay(
          Image(systemName: "fork.knife")
            .font(.system(size: 8, weight: .bold))
            .foregroundStyle(.black)
        )
        .position(x: 16, y: 16)

      Text("Meal Plan")
        .font(.system(size: 6.5, weight: .semibold))
        .foregroundStyle(.white)
        .frame(width: 124, alignment: .leading)
        .position(x: 94, y: 12)

      Text(kcalText(viewModel.mealCalories))
        .font(.system(size: 4.5, weight: .regular))
        .foregroundStyle(Color(red: 152 / 255, green: 152 / 255, blue: 157 / 255))
        .frame(width: 124, alignment: .leading)
        .position(x: 94, y: 22)

      Rectangle()
        .fill(Color(red: 38 / 255, green: 38 / 255, blue: 38 / 255))
        .frame(width: 152, height: 1)
        .position(x: 84, y: 55)

      Rectangle()
        .fill(Color(red: 38 / 255, green: 38 / 255, blue: 38 / 255))
        .frame(width: 152, height: 1)
        .position(x: 84, y: 84)

      ForEach(Array(displayMeals.prefix(3).enumerated()), id: \.element.id) { index, meal in
        figmaMealRow(index: index, meal: meal)
      }
    }
    .frame(width: 168, height: 120)
  }

  private func figmaMealRow(index: Int, meal: WatchMeal) -> some View {
    let titleY = [36.0, 65.0, 94.0][index]
    let timeY = [36.0, 68.0, 97.0][index]
    let caloriesY = [45.0, 74.0, 103.0][index]
    return ZStack(alignment: .topLeading) {
      Text(mealScheduleLabel(meal))
        .font(.system(size: 6, weight: .regular))
        .foregroundStyle(Color(red: 152 / 255, green: 152 / 255, blue: 157 / 255))
        .frame(width: 26, alignment: .leading)
        .position(x: 21, y: timeY)

      if meal.isCompleted {
        Image(systemName: "checkmark.circle")
          .font(.system(size: 7, weight: .bold))
          .foregroundStyle(Color(red: 34 / 255, green: 197 / 255, blue: 94 / 255))
          .position(x: 17, y: 46)
      }

      Text(meal.name)
        .font(.system(size: 6.5, weight: .medium))
        .foregroundStyle(meal.isCompleted ? WatchTheme.dimText : .white)
        .lineLimit(1)
        .minimumScaleFactor(0.7)
        .frame(width: 128, alignment: .leading)
        .position(x: 96, y: titleY)

      Text(caloriesText(meal.calories))
        .font(.system(size: 5.5, weight: .regular))
        .foregroundStyle(WatchTheme.dimText)
        .frame(width: 128, alignment: .leading)
        .position(x: 96, y: caloriesY)
    }
    .frame(width: 168, height: 120)
  }

  private func mealScheduleLabel(_ meal: WatchMeal) -> String {
    if let time = meal.scheduledTime?.trimmingCharacters(in: .whitespacesAndNewlines),
       !time.isEmpty {
      return String(time.prefix(5))
    }
    return "--:--"
  }
}

struct WorkoutLandingView: View {
  @ObservedObject var viewModel: WorkoutViewModel
  var plan: WatchWorkoutPlanSummary? = nil
  @State private var showsActiveWorkout = false
  @State private var showsCompletedWorkout = false

  var body: some View {
    DesignCanvas(height: 224) {
      ZStack(alignment: .topLeading) {
        Color(red: 15 / 255, green: 15 / 255, blue: 15 / 255)

        Circle()
          .fill(Color(red: 24 / 255, green: 24 / 255, blue: 27 / 255))
          .frame(width: 40, height: 40)
          .overlay {
            Circle()
              .stroke(WatchTheme.lime.opacity(0.7), lineWidth: 1.33)
          }
          .shadow(color: WatchTheme.lime.opacity(0.72), radius: 9)
          .overlay {
            Image(systemName: "figure.run")
              .font(.system(size: 12, weight: .bold))
              .foregroundStyle(WatchTheme.lime)
          }
          .position(x: 92, y: 47)

        Text((plan?.name ?? viewModel.homeWorkoutName).uppercased())
          .font(.system(size: 16, weight: .bold))
          .foregroundStyle(.white)
          .minimumScaleFactor(0.55)
          .lineLimit(1)
          .frame(width: 168)
          .position(x: 92, y: 88)

        Text(viewModel.displayedWorkoutStartLabel)
          .font(.system(size: 6, weight: .medium))
          .foregroundStyle(Color(red: 152 / 255, green: 152 / 255, blue: 157 / 255))
          .frame(width: 168)
          .position(x: 92, y: 110)

        Button {
          Task {
            if let plan {
              viewModel.selectWorkoutPlan(plan)
            } else {
              viewModel.selectTodayWorkout()
            }
            await viewModel.loadDisplayedWorkoutDetail()
            await viewModel.startWorkoutFromAPI()
            if viewModel.session.status == .active {
              showsActiveWorkout = true
            }
          }
        } label: {
          Group {
            if viewModel.isStartingWorkout {
              ProgressView()
                .controlSize(.mini)
                .tint(Color(red: 15 / 255, green: 15 / 255, blue: 15 / 255))
            } else {
              Label("START WORKOUT", systemImage: "play.fill")
            }
          }
            .font(.system(size: 8, weight: .bold))
            .foregroundStyle(Color(red: 15 / 255, green: 15 / 255, blue: 15 / 255))
            .frame(width: 168, height: 32)
            .background(
              WatchTheme.lime,
              in: RoundedRectangle(cornerRadius: 10, style: .continuous)
            )
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isStartingWorkout)
        .position(x: 92, y: 150)

        NavigationLink {
          ExerciseDetailView(viewModel: viewModel, plan: plan)
        } label: {
          Text("Show Info")
            .font(.system(size: 6.5, weight: .bold))
            .foregroundStyle(Color(red: 140 / 255, green: 140 / 255, blue: 148 / 255))
            .frame(width: 167, height: 23)
            .background(
              Color(red: 24 / 255, green: 24 / 255, blue: 27 / 255),
              in: RoundedRectangle(cornerRadius: 7.5, style: .continuous)
            )
            .overlay {
              RoundedRectangle(cornerRadius: 7.5, style: .continuous)
                .stroke(Color(red: 63 / 255, green: 63 / 255, blue: 70 / 255), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .position(x: 92, y: 184)
      }
    }
    .background(WatchTheme.background.ignoresSafeArea())
    .dynamicTypeSize(.xSmall ... .medium)
    .task(id: plan?.slug) {
      if let plan {
        viewModel.selectWorkoutPlan(plan)
      } else {
        viewModel.selectTodayWorkout()
      }
      await viewModel.loadDisplayedWorkoutDetail()
      if viewModel.isDisplayedWorkoutCompleted {
        viewModel.prepareCompletedWorkoutForDisplay()
        showsCompletedWorkout = true
      }
    }
    .navigationDestination(isPresented: $showsActiveWorkout) {
      ActiveWorkoutView(
        viewModel: viewModel,
        onBack: { showsActiveWorkout = false }
      )
    }
    .navigationDestination(isPresented: $showsCompletedWorkout) {
      WorkoutCompleteView(viewModel: viewModel, onDone: { showsCompletedWorkout = false })
    }
  }
}

struct ExerciseDetailView: View {
  @ObservedObject var viewModel: WorkoutViewModel
  var plan: WatchWorkoutPlanSummary? = nil
  @State private var showsActiveWorkout = false

  private var planExercise: WatchPlanExercise? {
    viewModel.displayedWorkoutDetail?.exercises.sorted(by: { $0.order < $1.order }).first
  }

  private var hasExercise: Bool {
    viewModel.currentExercise != nil || planExercise != nil
  }

  var body: some View {
    ScrollView {
      DesignCanvas(height: 246) {
        ZStack(alignment: .topLeading) {
          Color(red: 15 / 255, green: 15 / 255, blue: 15 / 255)

          Circle()
            .fill(Color(red: 24 / 255, green: 24 / 255, blue: 27 / 255))
            .frame(width: 40, height: 40)
            .overlay {
              Circle().stroke(WatchTheme.lime.opacity(0.7), lineWidth: 1.33)
            }
            .shadow(color: WatchTheme.lime.opacity(0.72), radius: 9)
            .overlay {
              Image(systemName: "figure.run")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(WatchTheme.lime)
            }
            .position(x: 92, y: 32)

          Text(exerciseName.uppercased())
            .font(.system(size: 9, weight: .medium))
            .foregroundStyle(.white)
            .minimumScaleFactor(0.55)
            .lineLimit(1)
            .frame(width: 168)
            .position(x: 92, y: 68)

          Text("\(viewModel.workoutName.uppercased()) • \(viewModel.displayedWorkoutStartLabel)")
            .font(.system(size: 5.5, weight: .medium))
            .foregroundStyle(WatchTheme.lime)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .padding(.horizontal, 5)
            .frame(maxWidth: 140, minHeight: 11)
            .background(WatchTheme.lime.opacity(0.1), in: Capsule())
            .position(x: 92, y: 86.5)

          infoCard(x: 48, y: 123.5, title: "WEIGHT", value: weightText, suffix: weightSuffix)
          infoCard(x: 136, y: 123.5, title: "REPS", value: repsText)
          infoCard(x: 48, y: 170.5, title: "REST", value: restText, suffix: "s")
          infoCard(x: 136, y: 170.5, title: "MUSCLE", value: muscleText)

          Button {
            Task {
              if let plan {
                viewModel.selectWorkoutPlan(plan)
                await viewModel.loadDisplayedWorkoutDetail()
              }
              await viewModel.startWorkoutFromAPI()
              if viewModel.session.status == .active {
                showsActiveWorkout = true
              }
            }
          } label: {
            Group {
              if viewModel.isStartingWorkout {
                ProgressView()
                  .controlSize(.mini)
                  .tint(Color(red: 15 / 255, green: 15 / 255, blue: 15 / 255))
              } else {
                Label("START WORKOUT", systemImage: "play.fill")
              }
            }
              .font(.system(size: 8, weight: .bold))
              .foregroundStyle(Color(red: 15 / 255, green: 15 / 255, blue: 15 / 255))
              .frame(width: 168, height: 32)
              .background(
                WatchTheme.lime,
                in: RoundedRectangle(cornerRadius: 10, style: .continuous)
              )
          }
          .buttonStyle(.plain)
          .disabled(!hasExercise || viewModel.isStartingWorkout)
          .position(x: 92, y: 218)

          if !hasExercise {
            ProgressView()
              .controlSize(.mini)
              .tint(WatchTheme.lime)
              .position(x: 92, y: 123)
          }
        }
      }
    }
    .background(WatchTheme.background.ignoresSafeArea())
    .dynamicTypeSize(.xSmall ... .medium)
    .task(id: plan?.slug) {
      if let plan {
        viewModel.selectWorkoutPlan(plan)
      } else {
        viewModel.selectTodayWorkout()
      }
      await viewModel.loadDisplayedWorkoutDetail()
      await viewModel.loadDisplayedExerciseHistory()
    }
    .refreshable {
      await viewModel.loadDisplayedWorkoutDetail(forceRefresh: true)
      await viewModel.loadDisplayedExerciseHistory(forceRefresh: true)
    }
    .navigationDestination(isPresented: $showsActiveWorkout) {
      ActiveWorkoutView(
        viewModel: viewModel,
        onBack: { showsActiveWorkout = false }
      )
    }
  }

  private var exerciseName: String {
    viewModel.currentExercise?.name ?? planExercise?.name ?? "No Exercise"
  }

  private var repsText: String {
    if let reps = viewModel.currentExercise?.reps { return "\(reps)" }
    return planExercise?.reps.map(String.init) ?? "--"
  }

  private var restText: String {
    if let rest = viewModel.currentExercise?.restSeconds { return "\(rest)" }
    return planExercise?.restSeconds.map(String.init) ?? "--"
  }

  private var muscleText: String {
    let category = viewModel.currentExercise?.category ?? planExercise?.category ?? ""
    return category.isEmpty ? "--" : category.capitalized
  }

  private var weightText: String {
    guard let weight = displayedWeight else { return "--" }
    return String(format: "%.0f", weight)
  }

  private var weightSuffix: String {
    displayedWeight == nil ? "" : "kg"
  }

  private var displayedWeight: Double? {
    viewModel.currentExercise?.weight
      ?? planExercise?.weight
      ?? viewModel.displayedExercisePreviousSet?.weight
  }

  private func infoCard(
    x: CGFloat,
    y: CGFloat,
    title: String,
    value: String,
    suffix: String = ""
  ) -> some View {
    VStack(spacing: 4) {
      Text(title)
        .font(.system(size: 5.5, weight: .regular))
        .foregroundStyle(.white)
      HStack(alignment: .firstTextBaseline, spacing: 2) {
        Text(value)
          .font(.system(size: 9, weight: .medium))
          .foregroundStyle(.white)
        if !suffix.isEmpty {
          Text(suffix)
            .font(.system(size: 5.5, weight: .medium))
            .foregroundStyle(.white)
        }
      }
    }
    .frame(width: 80, height: 39)
    .background(
      Color(red: 24 / 255, green: 24 / 255, blue: 27 / 255).opacity(0.6),
      in: RoundedRectangle(cornerRadius: 8, style: .continuous)
    )
    .position(x: x, y: y)
  }
}

struct ActiveWorkoutView: View {
  @ObservedObject var viewModel: WorkoutViewModel
  @Environment(\.dismiss) private var dismiss
  let onBack: (() -> Void)?
  @State private var currentDate = Date()
  @State private var showsWorkoutFinished = false
  private let topContentInset: CGFloat = 12

  init(viewModel: WorkoutViewModel, onBack: (() -> Void)? = nil) {
    self.viewModel = viewModel
    self.onBack = onBack
  }

  var body: some View {
    DesignCanvas(height: 224) {
      ZStack(alignment: .topLeading) {
        Button(action: goBack) {
          Image(systemName: "chevron.left")
            .font(.system(size: 15, weight: .bold))
            .foregroundStyle(.white)
            .frame(width: 40, height: 40)
            .background(
              Color(red: 31 / 255, green: 31 / 255, blue: 34 / 255),
              in: Circle()
            )
            .overlay {
              Circle()
                .stroke(Color.white.opacity(0.14), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.55), radius: 3, y: 2)
            .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .position(x: 24, y: 24 + topContentInset)
        .zIndex(10)
        .accessibilityLabel("Back")

        ZStack {
          Circle()
            .stroke(Color(red: 121 / 255, green: 121 / 255, blue: 121 / 255), lineWidth: 3.5)
          Circle()
            .trim(from: 0, to: ringProgress)
            .stroke(WatchTheme.lime, style: StrokeStyle(lineWidth: 3.5, lineCap: .round))
            .rotationEffect(.degrees(-90))
            .shadow(color: WatchTheme.lime.opacity(0.55), radius: 5)
          Text(timeText)
            .font(.system(size: 20, weight: .bold))
            .monospacedDigit()
            .minimumScaleFactor(0.75)
        }
        .frame(width: 76, height: 76)
        .position(x: 92, y: 49 + topContentInset)

        activeMetric(
          icon: "flame.fill",
          value: viewModel.activeCalories > 0 ? "\(viewModel.activeCalories)" : "--",
          label: "KCAL",
          tint: Color(red: 1, green: 103 / 255, blue: 17 / 255)
        )
        .position(x: 70, y: 114 + topContentInset)

        activeMetric(
          icon: "heart.fill",
          value: viewModel.averageHeartRate.map(String.init) ?? "--",
          label: "BPM",
          tint: Color(red: 1, green: 65 / 255, blue: 72 / 255)
        )
        .position(x: 112, y: 114 + topContentInset)

        HStack(spacing: 5) {
          Circle()
            .fill(Color(red: 0, green: 1, blue: 136 / 255))
            .frame(width: 4, height: 4)
          Text(activityLabel)
            .font(.system(size: 7, weight: .medium))
            .foregroundStyle(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.65)
        }
        .frame(width: 150, alignment: .center)
        .position(x: 92, y: 150 + topContentInset)

        Button(action: togglePause) {
          Label(
            viewModel.session.status == .paused ? "RESUME" : "PAUSE",
            systemImage: viewModel.session.status == .paused ? "play.fill" : "pause.fill"
          )
          .font(.system(size: 9, weight: .bold))
          .frame(width: 168, height: 32)
          .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .buttonStyle(ActiveWorkoutButtonStyle())
        .position(x: 92, y: 188 + topContentInset)
      }
    }
    .background(WatchTheme.background.ignoresSafeArea())
    .ignoresSafeArea()
    ._statusBarHidden(true)
    .navigationBarBackButtonHidden(true)
    .toolbar(.hidden, for: .navigationBar)
    .dynamicTypeSize(.xSmall ... .medium)
    .onAppear {
      showsWorkoutFinished = viewModel.session.status == .finished
      finishWhenTimerEnds(at: Date())
    }
    .task {
      await runWorkoutClock()
    }
    .navigationDestination(isPresented: $showsWorkoutFinished) {
      WorkoutFinishedView(viewModel: viewModel) {
        showsWorkoutFinished = false
        goBack()
      }
    }
  }

  private var timeText: String {
    let target = viewModel.remainingWorkoutSeconds(at: currentDate)
    return String(format: "%d:%02d", target / 60, target % 60)
  }

  private var ringProgress: Double {
    max(1 - viewModel.workoutTimeProgress(at: currentDate), 0.001)
  }

  private var activityLabel: String {
    let category = viewModel.activeWorkoutCategory.uppercased()
    return category == "STRENGTH" ? "STRENGTH TRAINING" : category
  }

  private func goBack() {
    if let onBack {
      onBack()
    } else {
      dismiss()
    }
  }

  private func togglePause() {
    if viewModel.session.status == .paused {
      viewModel.resumeWorkout()
    } else {
      viewModel.pauseWorkout()
    }
    currentDate = Date()
  }

  private func finishWhenTimerEnds(at date: Date) {
    guard viewModel.activeWorkoutDurationMinutes > 0,
          viewModel.session.status == .active,
          viewModel.remainingWorkoutSeconds(at: date) == 0 else { return }
    viewModel.finishWorkout()
    showsWorkoutFinished = true
  }

  @MainActor
  private func runWorkoutClock() async {
    while !Task.isCancelled {
      let date = Date()
      currentDate = date
      finishWhenTimerEnds(at: date)

      do {
        try await Task.sleep(nanoseconds: 1_000_000_000)
      } catch {
        return
      }
    }
  }

  private func activeMetric(
    icon: String,
    value: String,
    label: String,
    tint: Color
  ) -> some View {
    VStack(spacing: 2) {
      Image(systemName: icon)
        .font(.system(size: 8.5, weight: .semibold))
        .foregroundStyle(tint)
      Text(value)
        .font(.system(size: 13, weight: .bold))
        .foregroundStyle(tint)
        .monospacedDigit()
      Text(label)
        .font(.system(size: 7, weight: .bold))
        .foregroundStyle(Color(red: 121 / 255, green: 121 / 255, blue: 121 / 255))
    }
    .frame(width: 38, height: 43)
  }
}

private struct ActiveWorkoutButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .foregroundStyle(.white.opacity(configuration.isPressed ? 0.72 : 1))
      .background(
        Color.white.opacity(configuration.isPressed ? 0.16 : 0.10),
        in: RoundedRectangle(cornerRadius: 10, style: .continuous)
      )
      .overlay(
        RoundedRectangle(cornerRadius: 10, style: .continuous)
          .stroke(WatchTheme.lime, lineWidth: 0.5)
      )
      .shadow(color: WatchTheme.lime.opacity(0.18), radius: 6)
  }
}

struct WorkoutFinishedView: View {
  @ObservedObject var viewModel: WorkoutViewModel
  let onDone: (() -> Void)?
  @State private var showsStatistics = false
  @Environment(\.dismiss) private var dismiss
  private let topContentInset: CGFloat = 7

  init(viewModel: WorkoutViewModel, onDone: (() -> Void)? = nil) {
    self.viewModel = viewModel
    self.onDone = onDone
  }

  var body: some View {
    DesignCanvas(height: 239) {
      ZStack(alignment: .topLeading) {
        Color(red: 15 / 255, green: 15 / 255, blue: 15 / 255)

        Button(action: goBack) {
          Image(systemName: "chevron.left")
            .font(.system(size: 12, weight: .bold))
            .foregroundStyle(.white)
            .frame(width: 34, height: 34)
            .background(Color(red: 31 / 255, green: 31 / 255, blue: 34 / 255), in: Circle())
            .overlay { Circle().stroke(Color.white.opacity(0.14), lineWidth: 1) }
            .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .position(x: 22, y: 32 + topContentInset)
        .zIndex(10)
        .accessibilityLabel("Back")

        ZStack {
          Circle()
            .fill(
              LinearGradient(
                colors: [
                  Color(red: 1, green: 123 / 255, blue: 0),
                  Color(red: 1, green: 191 / 255, blue: 0)
                ],
                startPoint: .top,
                endPoint: .bottom
              )
            )
          Image(systemName: "trophy.fill")
            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(.black)
        }
        .frame(width: 22, height: 22)
        .position(x: 92, y: 24 + topContentInset)

        Text("Workout Complete")
          .font(.system(size: 10, weight: .bold))
          .foregroundStyle(.white)
          .frame(width: 170)
          .position(x: 92, y: 47 + topContentInset)

        Text(viewModel.activeWorkoutName.uppercased())
          .font(.system(size: 5.5, weight: .semibold))
          .foregroundStyle(Color(red: 154 / 255, green: 154 / 255, blue: 160 / 255))
          .lineLimit(1)
          .minimumScaleFactor(0.7)
          .frame(width: 160)
          .position(x: 92, y: 60 + topContentInset)

        completionRow(
          icon: "dumbbell.fill",
          title: "Total Volume",
          value: volumeText,
          tint: Color(red: 1, green: 174 / 255, blue: 0)
        )
        .position(x: 92, y: 91 + topContentInset)

        completionRow(
          icon: "heart.fill",
          title: "Heart Rate",
          value: heartRateText,
          tint: Color(red: 1, green: 65 / 255, blue: 72 / 255)
        )
        .position(x: 92, y: 128 + topContentInset)

        completionRow(
          icon: "timer",
          title: "Duration",
          value: durationText,
          tint: WatchTheme.lime
        )
        .position(x: 92, y: 165 + topContentInset)

        Button(action: finishAndShowStatistics) {
          Group {
            if viewModel.isCompletingWorkout {
              ProgressView()
                .tint(.black)
            } else {
              Text("FINISH")
                .font(.system(size: 9, weight: .bold))
            }
          }
          .foregroundStyle(.black)
          .frame(width: 168, height: 32)
          .background(WatchTheme.lime, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
          .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isCompletingWorkout)
        .position(x: 92, y: 211 + topContentInset)
      }
    }
    .background(WatchTheme.background.ignoresSafeArea())
    .ignoresSafeArea()
    ._statusBarHidden(true)
    .navigationBarBackButtonHidden(true)
    .toolbar(.hidden, for: .navigationBar)
    .dynamicTypeSize(.xSmall ... .medium)
    .navigationDestination(isPresented: $showsStatistics) {
      WorkoutCompleteView(viewModel: viewModel, onDone: onDone)
    }
  }

  private func completionRow(
    icon: String,
    title: String,
    value: String,
    tint: Color
  ) -> some View {
    HStack(spacing: 8) {
      Image(systemName: icon)
        .font(.system(size: 10, weight: .semibold))
        .foregroundStyle(tint)
        .frame(width: 22, height: 22)
        .background(tint.opacity(0.12), in: Circle())

      Text(title)
        .font(.system(size: 7.5, weight: .semibold))
        .foregroundStyle(.white)

      Spacer(minLength: 4)

      Text(value)
        .font(.system(size: 7.5, weight: .bold))
        .foregroundStyle(.white)
        .monospacedDigit()
        .lineLimit(1)
    }
    .padding(.horizontal, 10)
    .frame(width: 168, height: 31)
    .background(
      Color(red: 22 / 255, green: 22 / 255, blue: 25 / 255),
      in: RoundedRectangle(cornerRadius: 9, style: .continuous)
    )
    .overlay {
      RoundedRectangle(cornerRadius: 9, style: .continuous)
        .stroke(Color.white.opacity(0.08), lineWidth: 0.8)
    }
  }

  private var volumeText: String {
    guard viewModel.completedVolume > 0 else { return "-- kg" }
    return "\(Int(viewModel.completedVolume.rounded()).formatted()) kg"
  }

  private var heartRateText: String {
    viewModel.averageHeartRate.map { "\($0) bpm" } ?? "-- bpm"
  }

  private var durationText: String {
    let seconds = viewModel.activeElapsedSeconds(at: viewModel.session.finishedAt ?? Date())
    return "\(seconds / 60) m \(seconds % 60) s"
  }

  private func finishAndShowStatistics() {
    Task {
      await viewModel.submitFinishedWorkout()
      showsStatistics = true
    }
  }

  private func goBack() {
    if let onDone {
      onDone()
    } else {
      dismiss()
    }
  }
}

struct WorkoutCompleteView: View {
  @ObservedObject var viewModel: WorkoutViewModel
  @Environment(\.dismiss) private var dismiss
  let onDone: (() -> Void)?
  private let completionTopInset: CGFloat = 12

  init(viewModel: WorkoutViewModel, onDone: (() -> Void)? = nil) {
    self.viewModel = viewModel
    self.onDone = onDone
  }

  var body: some View {
    ScrollView {
      DesignCanvas(height: 720) {
        ZStack(alignment: .topLeading) {
          Color(red: 15 / 255, green: 15 / 255, blue: 15 / 255)

          Text("Workout Complete")
            .font(.system(size: 9, weight: .bold))
            .foregroundStyle(WatchTheme.lime)
            .frame(width: 168)
            .position(x: 92, y: 20 + completionTopInset)

          Text(completionSubtitle)
            .font(.system(size: 6, weight: .regular))
            .foregroundStyle(Color(red: 152 / 255, green: 152 / 255, blue: 157 / 255))
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .frame(width: 168)
            .position(x: 92, y: 34 + completionTopInset)

          goalRing
            .position(x: 92, y: 95 + completionTopInset)

          completionMetric(
            icon: "flame.fill",
            value: viewModel.completedCalories.map(String.init) ?? "--",
            title: "Total Cal",
            subtitle: calorieGoalText,
            tint: Color(red: 1, green: 103 / 255, blue: 17 / 255),
            background: Color(red: 77 / 255, green: 37 / 255, blue: 16 / 255)
          )
          .position(x: 48, y: 188.5 + completionTopInset)

          completionMetric(
            icon: "heart",
            value: viewModel.averageHeartRate.map(String.init) ?? "--",
            title: "Avg HR",
            subtitle: maxHeartRateText,
            tint: Color(red: 1, green: 65 / 255, blue: 92 / 255),
            background: Color(red: 77 / 255, green: 22 / 255, blue: 37 / 255)
          )
          .position(x: 136, y: 188.5 + completionTopInset)

          completionMetric(
            icon: "location.circle",
            value: distanceText,
            title: "Distance",
            subtitle: "Kilometers",
            tint: Color(red: 47 / 255, green: 128 / 255, blue: 1),
            background: Color(red: 20 / 255, green: 48 / 255, blue: 91 / 255)
          )
          .position(x: 48, y: 267.5 + completionTopInset)

          completionMetric(
            icon: "bolt.fill",
            value: powerText,
            title: "Watts",
            subtitle: "Avg Power",
            tint: Color(red: 1, green: 190 / 255, blue: 0),
            background: Color(red: 76 / 255, green: 59 / 255, blue: 4 / 255)
          )
          .position(x: 136, y: 267.5 + completionTopInset)

          heartRateZonesCard
            .position(x: 92, y: 375 + completionTopInset)

          highlightsCard
            .position(x: 92, y: 489.5 + completionTopInset)

          if let achievement = primaryAchievement {
            Text("Achievements Unlocked")
              .font(.system(size: 6, weight: .semibold))
              .foregroundStyle(.white)
              .frame(width: 168, alignment: .leading)
              .position(x: 92, y: 551 + completionTopInset)

            completionStatusRow(
              icon: achievement.systemImage,
              title: achievement.title,
              subtitle: achievement.subtitle ?? "",
              tint: Color(red: 1, green: 86 / 255, blue: 24 / 255)
            )
            .position(x: 92, y: 584 + completionTopInset)
          }

          completionStatusRow(
            icon: syncSucceeded ? "checkmark.icloud.fill" : "arrow.triangle.2.circlepath",
            title: syncSucceeded ? "Sync Complete" : "Sync Pending",
            subtitle: syncSucceeded ? "Workout saved to your account" : "Saved safely for later sync",
            tint: Color(red: 1, green: 182 / 255, blue: 0)
          )
          .position(x: 92, y: (primaryAchievement == nil ? 584 : 626) + completionTopInset)

          Button(action: finishSummary) {
            Text("Done")
              .font(.system(size: 9, weight: .bold))
              .foregroundStyle(Color(red: 15 / 255, green: 15 / 255, blue: 15 / 255))
              .frame(width: 152, height: 32)
              .background(WatchTheme.lime, in: Capsule())
          }
          .buttonStyle(.plain)
          .position(x: 92, y: 676 + completionTopInset)
        }
      }
    }
    .background(WatchTheme.background.ignoresSafeArea())
    .ignoresSafeArea()
    .navigationBarBackButtonHidden(true)
    .toolbar(.hidden, for: .navigationBar)
    .dynamicTypeSize(.xSmall ... .medium)
  }

  private var goalRing: some View {
    let progress = viewModel.workoutGoalProgress
    return ZStack {
      Circle()
        .stroke(Color(red: 126 / 255, green: 126 / 255, blue: 126 / 255), lineWidth: 5)
      Circle()
        .trim(from: 0, to: max(progress ?? 0, 0.001))
        .stroke(WatchTheme.lime, style: StrokeStyle(lineWidth: 5, lineCap: .round))
        .rotationEffect(.degrees(-90))
        .shadow(color: progress == nil ? .clear : WatchTheme.lime.opacity(0.55), radius: 5)
      VStack(spacing: 1) {
        Text(progress.map { "\(Int(($0 * 100).rounded()))%" } ?? "--%")
          .font(.system(size: 22, weight: .bold))
          .foregroundStyle(.white)
          .monospacedDigit()
        Text(progress.map { $0 >= 1 ? "GOAL MET" : "GOAL PROGRESS" } ?? "NOT PROVIDED")
          .font(.system(size: 6, weight: .medium))
          .foregroundStyle(Color(red: 121 / 255, green: 121 / 255, blue: 121 / 255))
      }
    }
    .frame(width: 86, height: 86)
  }

  private var heartRateZonesCard: some View {
    ZStack(alignment: .topLeading) {
      RoundedRectangle(cornerRadius: 8, style: .continuous)
        .fill(Color(red: 24 / 255, green: 24 / 255, blue: 27 / 255))
      Text("Heart Rate Zones")
        .font(.system(size: 6, weight: .semibold))
        .foregroundStyle(.white)
        .position(x: 38, y: 13)
      Image(systemName: "waveform.path.ecg")
        .font(.system(size: 8, weight: .medium))
        .foregroundStyle(Color(red: 1, green: 65 / 255, blue: 92 / 255))
        .position(x: 156, y: 13)
      zoneRow(
        y: 29,
        title: "Peak",
        value: viewModel.completionSummary?.heartRateZones.peak,
        tint: Color(red: 232 / 255, green: 27 / 255, blue: 75 / 255)
      )
      zoneRow(
        y: 50,
        title: "Cardio",
        value: viewModel.completionSummary?.heartRateZones.cardio,
        tint: Color(red: 1, green: 103 / 255, blue: 17 / 255)
      )
      zoneRow(
        y: 71,
        title: "Fat Burn",
        value: viewModel.completionSummary?.heartRateZones.fatBurn,
        tint: Color(red: 0, green: 190 / 255, blue: 125 / 255)
      )
      zoneRow(
        y: 92,
        title: "Warm-up",
        value: viewModel.completionSummary?.heartRateZones.warmUp,
        tint: Color(red: 47 / 255, green: 128 / 255, blue: 1)
      )
    }
    .frame(width: 168, height: 112)
  }

  private var highlightsCard: some View {
    ZStack(alignment: .topLeading) {
      RoundedRectangle(cornerRadius: 8, style: .continuous)
        .fill(Color(red: 24 / 255, green: 24 / 255, blue: 27 / 255))
      Text("HIGHLIGHTS")
        .font(.system(size: 6, weight: .bold))
        .foregroundStyle(WatchTheme.lime)
        .position(x: 35, y: 14)
      highlightRow(y: 34, title: "Peak Heart Rate", value: peakHeartRateText)
      Divider().overlay(Color.white.opacity(0.08)).frame(width: 152).position(x: 84, y: 44)
      highlightRow(y: 54, title: "Duration", value: durationHighlightText)
      Divider().overlay(Color.white.opacity(0.08)).frame(width: 152).position(x: 84, y: 64)
      highlightRow(y: 74, title: "Recovery Time", value: recoveryText)
    }
    .frame(width: 168, height: 85)
  }

  private func completionMetric(
    icon: String,
    value: String,
    title: String,
    subtitle: String,
    tint: Color,
    background: Color
  ) -> some View {
    ZStack(alignment: .topLeading) {
      RoundedRectangle(cornerRadius: 8, style: .continuous)
        .fill(Color(red: 24 / 255, green: 24 / 255, blue: 27 / 255).opacity(0.6))
      Circle()
        .fill(background)
        .frame(width: 18, height: 18)
        .overlay(Image(systemName: icon).font(.system(size: 9, weight: .semibold)).foregroundStyle(tint))
        .position(x: 19, y: 17)
      Text(value)
        .font(.system(size: 10, weight: .bold))
        .foregroundStyle(.white)
        .lineLimit(1)
        .minimumScaleFactor(0.7)
        .frame(width: 64, alignment: .leading)
        .position(x: 40, y: 39)
      Text(title)
        .font(.system(size: 6, weight: .regular))
        .foregroundStyle(Color(red: 174 / 255, green: 174 / 255, blue: 181 / 255))
        .frame(width: 64, alignment: .leading)
        .position(x: 40, y: 52)
      Text(subtitle)
        .font(.system(size: 5.5, weight: .regular))
        .foregroundStyle(Color(red: 121 / 255, green: 121 / 255, blue: 121 / 255))
        .lineLimit(1)
        .minimumScaleFactor(0.7)
        .frame(width: 64, alignment: .leading)
        .position(x: 40, y: 63)
    }
    .frame(width: 80, height: 71)
  }

  private func zoneRow(y: CGFloat, title: String, value: Double?, tint: Color) -> some View {
    ZStack(alignment: .topLeading) {
      Text(title)
        .font(.system(size: 5.5, weight: .regular))
        .foregroundStyle(Color(red: 174 / 255, green: 174 / 255, blue: 181 / 255))
        .position(x: 29, y: 3)
      Text(value.map { "\(Int(($0 * 100).rounded()))%" } ?? "--%")
        .font(.system(size: 5.5, weight: .regular))
        .foregroundStyle(Color(red: 174 / 255, green: 174 / 255, blue: 181 / 255))
        .position(x: 148, y: 3)
      Capsule().fill(Color.white.opacity(0.08)).frame(width: 152, height: 4).position(x: 84, y: 12)
      Capsule()
        .fill(tint)
        .frame(width: max(152 * (value ?? 0), value == nil ? 0 : 4), height: 4)
        .position(x: 8 + max(152 * (value ?? 0), value == nil ? 0 : 4) / 2, y: 12)
    }
    .frame(width: 168, height: 16)
    .position(x: 84, y: y)
  }

  private func highlightRow(y: CGFloat, title: String, value: String) -> some View {
    HStack {
      Text(title).foregroundStyle(Color(red: 174 / 255, green: 174 / 255, blue: 181 / 255))
      Spacer()
      Text(value).foregroundStyle(.white)
    }
    .font(.system(size: 5.5, weight: .medium))
    .frame(width: 152)
    .position(x: 84, y: y)
  }

  private func completionStatusRow(
    icon: String,
    title: String,
    subtitle: String,
    tint: Color
  ) -> some View {
    HStack(spacing: 9) {
      Circle()
        .fill(tint)
        .frame(width: 22, height: 22)
        .overlay(Image(systemName: icon).font(.system(size: 9, weight: .bold)).foregroundStyle(.white))
      VStack(alignment: .leading, spacing: 2) {
        Text(title).font(.system(size: 7, weight: .semibold)).foregroundStyle(.white)
        Text(subtitle)
          .font(.system(size: 5.5, weight: .regular))
          .foregroundStyle(Color(red: 174 / 255, green: 174 / 255, blue: 181 / 255))
          .lineLimit(1)
          .minimumScaleFactor(0.75)
      }
      Spacer(minLength: 0)
    }
    .padding(.horizontal, 8)
    .frame(width: 168, height: 36)
    .background(Color(red: 24 / 255, green: 24 / 255, blue: 27 / 255), in: RoundedRectangle(cornerRadius: 8))
  }

  private var completionSubtitle: String {
    let summary = viewModel.completionSummary
    let name = summary?.workoutName ?? summary?.workoutCategory ?? viewModel.activeWorkoutName
    let finishedAt = summary?.finishedAt ?? viewModel.session.finishedAt ?? Date()
    return "\(name) • Today, \(Self.timeFormatter.string(from: finishedAt))"
  }

  private var calorieGoalText: String {
    viewModel.completionSummary?.calorieGoal.map { "Goal: \($0)" } ?? "Goal unavailable"
  }

  private var maxHeartRateText: String {
    viewModel.completionSummary?.maxHeartRate.map { "Max: \($0) bpm" } ?? "HealthKit unavailable"
  }

  private var distanceText: String {
    viewModel.completionSummary?.distanceKilometers.map { String(format: "%.1f", $0) } ?? "--"
  }

  private var powerText: String {
    viewModel.completionSummary?.averagePower.map(String.init) ?? "--"
  }

  private var peakHeartRateText: String {
    viewModel.completionSummary?.maxHeartRate.map { "\($0) BPM" } ?? "-- BPM"
  }

  private var recoveryText: String {
    viewModel.completionSummary?.recoveryMinutes.map { "\($0) MINS" } ?? "-- MINS"
  }

  private var syncSucceeded: Bool {
    viewModel.syncMessage == "Workout synced"
      || viewModel.syncMessage == "Workout saved; statistics unavailable"
  }

  private var primaryAchievement: WatchWorkoutAchievement? {
    viewModel.completionSummary?.achievements.first
  }

  private var durationHighlightText: String {
    viewModel.completionSummary?.actualDurationMinutes.map { "\($0) MIN" } ?? "-- MIN"
  }

  private func finishSummary() {
    viewModel.resetWorkout()
    if let onDone {
      onDone()
    } else {
      dismiss()
    }
  }

  private static let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "h:mm a"
    return formatter
  }()
}

private struct DesignCanvas<Content: View>: View {
  let height: CGFloat
  let referenceWidth: CGFloat
  let content: Content

  init(
    height: CGFloat,
    referenceWidth: CGFloat = 184,
    @ViewBuilder content: () -> Content
  ) {
    self.height = height
    self.referenceWidth = referenceWidth
    self.content = content()
  }

  var body: some View {
    GeometryReader { geometry in
      let scale = min(geometry.size.width / referenceWidth, 1)
      content
        .frame(width: 184, height: height)
        .background(WatchTheme.background)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .scaleEffect(scale, anchor: .top)
        .frame(width: geometry.size.width, height: height * scale, alignment: .top)
    }
    .frame(height: scaledHeightFallback)
  }

  private var scaledHeightFallback: CGFloat {
    height
  }
}

private struct HomeHeader: View {
  var body: some View {
    VStack(spacing: 2) {
      Text(Self.timeFormatter.string(from: Date()))
        .font(.system(size: 36, weight: .bold, design: .rounded))
        .monospacedDigit()
      Text(Self.dateFormatter.string(from: Date()))
        .font(.system(size: 14, weight: .regular))
        .foregroundStyle(.secondary)
      Capsule()
        .fill(.white)
        .frame(width: 18, height: 3)
        .padding(.top, 4)
    }
  }

  static let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "h:mm"
    return formatter
  }()

  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MMM d"
    return formatter
  }()
}

private struct WatchCard<Content: View>: View {
  @ViewBuilder var content: Content

  var body: some View {
    content
      .padding(9)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(WatchTheme.card, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
      .overlay(
        RoundedRectangle(cornerRadius: 12, style: .continuous)
          .stroke(.white.opacity(0.08), lineWidth: 1)
      )
  }
}

private struct MiniSummaryCard: View {
  let icon: String
  let title: String
  let subtitle: String
  let tint: Color

  var body: some View {
    HStack(spacing: 8) {
      Image(systemName: icon)
        .font(.system(size: 14, weight: .bold))
        .foregroundStyle(tint)
        .frame(width: 16)
      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .font(.system(size: 11, weight: .semibold))
          .fontWeight(.semibold)
          .lineLimit(1)
          .minimumScaleFactor(0.75)
        Text(subtitle)
          .font(.system(size: 9, weight: .regular))
          .foregroundStyle(.secondary)
          .lineLimit(1)
          .minimumScaleFactor(0.55)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.horizontal, 7)
    .padding(.vertical, 8)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(WatchTheme.card, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
  }
}

private struct TileMetric: View {
  let icon: String
  let title: String
  let value: String
  let tint: Color

  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      Label(title, systemImage: icon)
        .font(.system(size: 6, weight: .semibold))
        .foregroundStyle(tint)
        .lineLimit(1)
      Text(value)
        .font(.system(size: 10, weight: .bold))
        .fontWeight(.bold)
        .lineLimit(1)
    }
    .padding(6)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(.white.opacity(0.04), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
  }
}

private struct MealRow: View {
  let time: String
  let meal: WatchMeal

  var body: some View {
    HStack(alignment: .top, spacing: 10) {
      Text(time)
        .font(.system(size: 7, weight: .regular))
        .foregroundStyle(.secondary)
        .frame(width: 44, alignment: .leading)
      VStack(alignment: .leading, spacing: 2) {
        Text(meal.name.isEmpty ? meal.mealType.capitalized : meal.name)
          .font(.system(size: 8, weight: .semibold))
          .fontWeight(.semibold)
          .lineLimit(1)
        Text(caloriesText(meal.calories))
          .font(.system(size: 7, weight: .regular))
          .foregroundStyle(.secondary)
      }
      Spacer()
      if meal.isCompleted {
        Image(systemName: "checkmark.circle.fill")
          .foregroundStyle(.green)
      }
    }
  }
}

private struct NeonIcon: View {
  let symbol: String
  let size: CGFloat

  var body: some View {
    Circle()
      .fill(WatchTheme.lime)
      .frame(width: size, height: size)
      .overlay(Image(systemName: symbol).font(.system(size: 15, weight: .bold)).foregroundStyle(.black))
  }
}

private struct GlowExerciseIcon: View {
  let size: CGFloat

  var body: some View {
    Circle()
      .stroke(WatchTheme.lime, lineWidth: 4)
      .frame(width: size, height: size)
      .shadow(color: WatchTheme.lime.opacity(0.8), radius: 16)
      .overlay(Image(systemName: "figure.run").font(.system(size: 22, weight: .bold)).foregroundStyle(WatchTheme.lime))
  }
}

private struct StatCard: View {
  let title: String
  let value: String
  var suffix = ""

  var body: some View {
    VStack(spacing: 5) {
      Text(title)
        .font(.system(size: 12, weight: .regular))
      HStack(alignment: .firstTextBaseline, spacing: 2) {
        Text(value)
          .font(.system(size: 22, weight: .bold))
          .minimumScaleFactor(0.65)
        if !suffix.isEmpty {
          Text(suffix)
            .font(.system(size: 13, weight: .bold))
            .fontWeight(.bold)
        }
      }
    }
    .frame(maxWidth: .infinity, minHeight: 62)
    .background(WatchTheme.card, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
  }
}

private struct NeonButtonStyle: ButtonStyle {
  var compact = false

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(.vertical, compact ? 7 : 12)
      .padding(.horizontal, 8)
      .foregroundStyle(.black)
      .background(WatchTheme.lime.opacity(configuration.isPressed ? 0.72 : 1), in: RoundedRectangle(cornerRadius: compact ? 10 : 22, style: .continuous))
  }
}

private struct OutlineButtonStyle: ButtonStyle {
  var limeBorder = false

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(.vertical, 10)
      .padding(.horizontal, 8)
      .foregroundStyle(.white)
      .background(.white.opacity(configuration.isPressed ? 0.13 : 0.08), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
      .overlay(
        RoundedRectangle(cornerRadius: 22, style: .continuous)
          .stroke(limeBorder ? WatchTheme.lime : .white.opacity(0.22), lineWidth: limeBorder ? 1.4 : 1)
      )
  }
}

private enum WatchTheme {
  static let lime = Color(red: 0.82, green: 1.0, blue: 0.0)
  static let background = Color.black
  static let card = Color(red: 0.08, green: 0.08, blue: 0.095)
  static let muted = Color(red: 0.60, green: 0.60, blue: 0.62)
  static let dimText = Color(red: 0.45, green: 0.45, blue: 0.45)
}

private func numberText(_ value: Int?) -> String {
  value.map(String.init) ?? "--"
}

private func minutesText(_ value: Int?) -> String {
  value.map { "\($0) min" } ?? "-- min"
}

private func caloriesText(_ value: Int?) -> String {
  value.map { "\($0) cal" } ?? "-- cal"
}

private func kcalText(_ value: Int?) -> String {
  value.map { "\($0) KCAL" } ?? "-- KCAL"
}

private func countText(_ value: Int?, unit: String) -> String {
  value.map { "\($0) \(unit)" } ?? "-- \(unit)"
}
