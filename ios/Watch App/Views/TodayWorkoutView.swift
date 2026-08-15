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
            await viewModel.refreshHomeData()
          }
        }
    )
    .background(WatchTheme.background.ignoresSafeArea())
    .dynamicTypeSize(.xSmall ... .medium)
    .ignoresSafeArea()
    .refreshable {
      await viewModel.refreshHomeData()
    }
    .overlay(alignment: .top) {
      if viewModel.isRefreshing {
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

  private var quickCards: some View {
    HStack(spacing: 10) {
      MiniSummaryCard(
        icon: "dumbbell.fill",
        title: "Gym",
        subtitle: "\(shortCategory(viewModel.workoutCategory)) • \(viewModel.durationMinutes) min",
        tint: WatchTheme.lime
      )
      MiniSummaryCard(
        icon: "fork.knife",
        title: "Meals",
        subtitle: "\(viewModel.meals.count) meals • \(viewModel.mealCalories) cal",
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
            Text(viewModel.workoutName)
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
            TileMetric(icon: "timer", title: "Duration", value: "\(viewModel.durationMinutes) min", tint: WatchTheme.lime)
            TileMetric(icon: "flame.fill", title: "Cal", value: "\(viewModel.caloriesBurned)", tint: .orange)
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
              Text("\(viewModel.mealCalories) / 2,100 KCAL")
                .font(.caption2)
                .foregroundStyle(.secondary)
            }
          }

          ForEach(Array(viewModel.meals.prefix(3).enumerated()), id: \.element.id) { index, meal in
            MealRow(time: ["08:00", "13:00", "19:00"][index], meal: meal)
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
    viewModel.meals
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

      topTile(
        x: 8,
        icon: "dumbbell",
        title: "Sessions",
        subtitle: viewModel.workoutCategory.capitalized,
        detail: "\(viewModel.durationMinutes) min",
        rotatesIcon: true
      )
      topTile(
        x: 96,
        icon: "fork.knife.circle",
        title: "Meal Plan",
        subtitle: "\(viewModel.meals.count) meals",
        detail: "\(viewModel.mealCalories) cal"
      )

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

      Text(viewModel.workoutName)
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

      smallMetric(x: 8, icon: "timer", title: "Duration", value: "\(viewModel.durationMinutes) min", tint: Color(red: 212 / 255, green: 1, blue: 0))
      smallMetric(x: 88, icon: "flame.fill", title: "Cal", value: "\(viewModel.caloriesBurned)", tint: Color(red: 1, green: 105 / 255, blue: 20 / 255))

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

      Text("\(viewModel.mealCalories) / 2,100 KCAL")
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
    let times = ["08:00", "13:00", "19:00"]
    let titleY = [36.0, 65.0, 94.0][index]
    let timeY = [36.0, 68.0, 97.0][index]
    let caloriesY = [45.0, 74.0, 103.0][index]
    return ZStack(alignment: .topLeading) {
      Text(times[index])
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

      Text("\(meal.calories ?? 0) kcal")
        .font(.system(size: 5.5, weight: .regular))
        .foregroundStyle(WatchTheme.dimText)
        .frame(width: 128, alignment: .leading)
        .position(x: 96, y: caloriesY)
    }
    .frame(width: 168, height: 120)
  }
}

struct WorkoutLandingView: View {
  @ObservedObject var viewModel: WorkoutViewModel

  var body: some View {
    DesignCanvas(height: 224) {
      VStack(spacing: 14) {
        Spacer(minLength: 4)
        GlowExerciseIcon(size: 40)
        Text(viewModel.workoutName.uppercased())
          .font(.system(size: 22, weight: .bold))
          .minimumScaleFactor(0.55)
          .lineLimit(1)
        Text("STARTS AT \(viewModel.scheduledTimeText)")
          .font(.system(size: 9, weight: .semibold))
          .foregroundStyle(.secondary)
        Spacer(minLength: 4)
        NavigationLink {
          ExerciseDetailView(viewModel: viewModel)
            .onAppear {
              if viewModel.session.status == .idle || viewModel.session.status == .finished {
                viewModel.resetWorkout()
              }
            }
        } label: {
          Label("START WORKOUT", systemImage: "play.fill")
            .font(.system(size: 10, weight: .bold))
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(NeonButtonStyle())

        NavigationLink {
          ExerciseDetailView(viewModel: viewModel)
        } label: {
          Text("Show Info")
            .font(.system(size: 9, weight: .bold))
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(OutlineButtonStyle())
      }
      .padding(.horizontal, 8)
      .padding(.top, 27)
      .padding(.bottom, 28)
    }
    .background(WatchTheme.background.ignoresSafeArea())
    .dynamicTypeSize(.xSmall ... .medium)
  }
}

struct ExerciseDetailView: View {
  @ObservedObject var viewModel: WorkoutViewModel

  private var exercise: WatchExercise {
    viewModel.currentExercise ?? .fallback
  }

  var body: some View {
    DesignCanvas(height: 246) {
    VStack(spacing: 9) {
      GlowExerciseIcon(size: 40)
      Text(exercise.name.uppercased())
        .font(.system(size: 12, weight: .bold))
        .minimumScaleFactor(0.55)
        .multilineTextAlignment(.center)
        .lineLimit(2)
      Text("\(viewModel.workoutName.uppercased()) • STARTS AT \(viewModel.scheduledTimeText)")
        .font(.system(size: 6, weight: .bold))
        .fontWeight(.bold)
        .foregroundStyle(WatchTheme.lime)
        .lineLimit(1)
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(WatchTheme.lime.opacity(0.16), in: Capsule())

      LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
        StatCard(title: "WEIGHT", value: weightText(exercise.weight), suffix: exercise.weight == nil ? "" : "kg")
        StatCard(title: "REPS", value: "\(exercise.reps)")
        StatCard(title: "REST", value: "\(exercise.safeRestSeconds)", suffix: "s")
        StatCard(title: "MUSCLE", value: muscleText(exercise))
      }

      if let previousSet = exercise.previousSet {
        Text("Previous Set: \(previousText(previousSet))")
          .font(.caption2)
          .foregroundStyle(.secondary)
          .lineLimit(1)
      }

      NavigationLink {
        ActiveWorkoutView(viewModel: viewModel)
          .onAppear {
            if viewModel.session.status == .idle || viewModel.session.status == .finished {
              viewModel.startWorkout()
            }
          }
      } label: {
        Label("START WORKOUT", systemImage: "play.fill")
          .font(.system(size: 10, weight: .bold))
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(NeonButtonStyle())
    }
    .padding(.horizontal, 8)
    .padding(.top, 12)
    .padding(.bottom, 12)
    }
    .background(WatchTheme.background.ignoresSafeArea())
    .dynamicTypeSize(.xSmall ... .medium)
  }

  private func muscleText(_ exercise: WatchExercise) -> String {
    let category = exercise.category?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    return category.isEmpty ? "Quads" : category.capitalized
  }

  private func weightText(_ weight: Double?) -> String {
    guard let weight else { return "60" }
    return String(format: "%.0f", weight)
  }

  private func previousText(_ previousSet: PreviousSet) -> String {
    let reps = previousSet.reps.map { "\($0) reps" } ?? "-"
    let weight = previousSet.weight.map { String(format: "%.0f kg", $0) } ?? "-"
    return "\(reps), \(weight)"
  }
}

struct ActiveWorkoutView: View {
  @ObservedObject var viewModel: WorkoutViewModel
  @State private var elapsedSeconds = 0
  private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  var body: some View {
    DesignCanvas(height: 224) {
    VStack(spacing: 11) {
      ZStack {
        Circle()
          .stroke(.gray.opacity(0.55), lineWidth: 8)
        Circle()
          .trim(from: 0, to: max(0.18, viewModel.progressValue))
          .stroke(WatchTheme.lime, style: StrokeStyle(lineWidth: 8, lineCap: .round))
          .rotationEffect(.degrees(-90))
          .shadow(color: WatchTheme.lime.opacity(0.55), radius: 8)
        Text(timeText)
          .font(.system(size: 23, weight: .bold, design: .rounded))
          .monospacedDigit()
          .minimumScaleFactor(0.65)
      }
      .frame(width: 96, height: 96)

      HStack(spacing: 26) {
        BigMetric(icon: "flame.fill", value: "\(max(viewModel.activeCalories, 247))", label: "KCAL", tint: .orange)
        BigMetric(icon: "heart.fill", value: "\(viewModel.averageHeartRate)", label: "BPM", tint: .red)
      }

      HStack(spacing: 8) {
        Circle().fill(.green).frame(width: 8, height: 8)
        Text(viewModel.workoutCategory.uppercased())
          .font(.headline)
          .lineLimit(1)
          .minimumScaleFactor(0.7)
      }

      HStack(spacing: 8) {
        Button {
          if viewModel.session.status == .paused {
            viewModel.resumeWorkout()
          } else {
            viewModel.pauseWorkout()
          }
        } label: {
          Label(viewModel.session.status == .paused ? "RESUME" : "PAUSE", systemImage: viewModel.session.status == .paused ? "play.fill" : "pause.fill")
            .font(.system(size: 14, weight: .bold))
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(OutlineButtonStyle(limeBorder: true))

        NavigationLink {
          WorkoutCompleteView(viewModel: viewModel)
            .onAppear { viewModel.finishWorkout() }
        } label: {
          Image(systemName: "checkmark")
            .font(.headline)
        }
        .buttonStyle(NeonButtonStyle(compact: true))
        .frame(width: 48)
      }
    }
    .padding(.horizontal, 16)
    .padding(.top, 12)
    .padding(.bottom, 22)
    }
    .background(WatchTheme.background.ignoresSafeArea())
    .dynamicTypeSize(.xSmall ... .medium)
    .onReceive(ticker) { _ in
      guard viewModel.session.status == .active else { return }
      elapsedSeconds += 1
    }
  }

  private var timeText: String {
    let target = max(viewModel.durationMinutes * 60 - elapsedSeconds, 0)
    return String(format: "%d:%02d", target / 60, target % 60)
  }
}

struct WorkoutCompleteView: View {
  @ObservedObject var viewModel: WorkoutViewModel
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    ScrollView {
      DesignCanvas(height: 704) {
      VStack(spacing: 14) {
        VStack(spacing: 2) {
          Text("Workout Complete")
            .font(.system(size: 9, weight: .bold))
            .foregroundStyle(WatchTheme.lime)
          Text("\(viewModel.workoutCategory.capitalized) • Today")
            .font(.caption)
            .foregroundStyle(.secondary)
        }

        ZStack {
          Circle().stroke(.gray.opacity(0.55), lineWidth: 7)
          Circle()
            .trim(from: 0, to: max(viewModel.workoutGoalProgress, 0.75))
            .stroke(WatchTheme.lime, style: StrokeStyle(lineWidth: 7, lineCap: .round))
            .rotationEffect(.degrees(-90))
            .shadow(color: WatchTheme.lime.opacity(0.45), radius: 7)
          VStack(spacing: 0) {
            Text("\(Int(max(viewModel.workoutGoalProgress, 0.75) * 100))%")
              .font(.system(size: 22, weight: .bold))
            Text("GOAL MET")
              .font(.caption2)
              .foregroundStyle(.secondary)
          }
        }
        .frame(width: 86, height: 86)

        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
          SummaryTile(icon: "flame.fill", value: "\(max(viewModel.activeCalories, 560))", title: "Total Cal", subtitle: "Goal: 600", tint: .orange)
          SummaryTile(icon: "heart.fill", value: "\(viewModel.averageHeartRate)", title: "Avg HR", subtitle: "Max: 178 bpm", tint: .red)
          SummaryTile(icon: "location.circle.fill", value: "5.4", title: "Distance", subtitle: "Kilometers", tint: .blue)
          SummaryTile(icon: "bolt.fill", value: "320", title: "Watts", subtitle: "Avg Power", tint: .yellow)
        }

        ZoneCard()
        HighlightsCard()
        AchievementRow(icon: "flame.fill", title: "7 Day Streak", subtitle: "You're on fire! Keep it up.", tint: .orange)
        AchievementRow(icon: "trophy.fill", title: "New Personal Best", subtitle: "Fastest 5k run this month", tint: .yellow)

        Button {
          viewModel.resetWorkout()
          dismiss()
        } label: {
          Text("Done")
            .font(.system(size: 12, weight: .bold))
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(NeonButtonStyle())
      }
      .padding(.horizontal, 8)
      .padding(.top, 14)
      .padding(.bottom, 12)
      }
    }
    .background(WatchTheme.background.ignoresSafeArea())
    .dynamicTypeSize(.xSmall ... .medium)
  }
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
        Text("\(meal.calories ?? 0) kcal")
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

private struct BigMetric: View {
  let icon: String
  let value: String
  let label: String
  let tint: Color

  var body: some View {
    VStack(spacing: 3) {
      Image(systemName: icon).foregroundStyle(tint)
      Text(value)
        .font(.system(size: 27, weight: .bold))
        .foregroundStyle(tint)
      Text(label)
        .font(.system(size: 15, weight: .bold))
        .foregroundStyle(.secondary)
    }
  }
}

private struct SummaryTile: View {
  let icon: String
  let value: String
  let title: String
  let subtitle: String
  let tint: Color

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Image(systemName: icon)
        .foregroundStyle(tint)
      Text(value)
        .font(.system(size: 15, weight: .bold))
        .fontWeight(.bold)
      Text(title)
        .font(.caption2)
        .foregroundStyle(.secondary)
      Text(subtitle)
        .font(.caption2)
        .foregroundStyle(.secondary)
        .lineLimit(1)
    }
    .padding(8)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(WatchTheme.card, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
  }
}

private struct ZoneCard: View {
  var body: some View {
    WatchCard {
      VStack(alignment: .leading, spacing: 8) {
        HStack {
          Text("Heart Rate Zones")
            .font(.caption)
            .fontWeight(.bold)
          Spacer()
          Image(systemName: "waveform.path.ecg").foregroundStyle(.red)
        }
        ZoneRow(name: "Peak", value: 0.12, tint: .red)
        ZoneRow(name: "Cardio", value: 0.55, tint: .orange)
        ZoneRow(name: "Fat Burn", value: 0.33, tint: .green)
        ZoneRow(name: "Warm-up", value: 0.24, tint: .blue)
      }
    }
  }
}

private struct ZoneRow: View {
  let name: String
  let value: Double
  let tint: Color

  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      HStack {
        Text(name).font(.caption2).foregroundStyle(.secondary)
        Spacer()
        Text("\(Int(value * 100))%").font(.caption2).foregroundStyle(.secondary)
      }
      ProgressView(value: value)
        .tint(tint)
    }
  }
}

private struct HighlightsCard: View {
  var body: some View {
    WatchCard {
      VStack(spacing: 8) {
        HStack {
          Text("HIGHLIGHTS")
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundStyle(WatchTheme.lime)
          Spacer()
        }
        HighlightRow(title: "Peak Heart Rate", value: "178 BPM")
        HighlightRow(title: "Avg Duration", value: "142 BPM")
        HighlightRow(title: "Recovery Time", value: "2 MINS")
      }
    }
  }
}

private struct HighlightRow: View {
  let title: String
  let value: String

  var body: some View {
    HStack {
      Text(title)
        .font(.caption2)
        .foregroundStyle(.secondary)
      Spacer()
      Text(value)
        .font(.caption2)
        .fontWeight(.bold)
    }
  }
}

private struct AchievementRow: View {
  let icon: String
  let title: String
  let subtitle: String
  let tint: Color

  var body: some View {
    HStack(spacing: 10) {
      Circle()
        .fill(tint)
        .frame(width: 30, height: 30)
        .overlay(Image(systemName: icon).foregroundStyle(.white))
      VStack(alignment: .leading, spacing: 2) {
        Text(title)
          .font(.system(size: 14, weight: .bold))
          .fontWeight(.bold)
        Text(subtitle)
          .font(.caption2)
          .foregroundStyle(.secondary)
          .lineLimit(1)
      }
    }
    .padding(8)
    .frame(maxWidth: .infinity, alignment: .leading)
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

private extension WatchExercise {
  static let fallback = WatchExercise(
    id: 0,
    exerciseId: "fallback",
    name: "Barbell Back Squat",
    sets: 4,
    reps: 10,
    weight: 60,
    previousSet: PreviousSet(reps: 10, weight: 55),
    restSeconds: 90,
    order: 0,
    unit: "kg",
    category: "Quads"
  )
}
