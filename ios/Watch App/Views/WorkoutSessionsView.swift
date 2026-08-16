import SwiftUI

struct WorkoutSessionsView: View {
  @ObservedObject var viewModel: WorkoutViewModel
  @State private var selectedPlanID: Int?

  private var canvasHeight: CGFloat {
    max(224, 44 + CGFloat(viewModel.workoutPlans.count) * 58)
  }

  var body: some View {
    ScrollView {
      SessionsDesignCanvas(height: canvasHeight) {
        ZStack(alignment: .top) {
          SessionsTheme.background

          Text("START WORKOUT")
            .font(.system(size: 7.5, weight: .bold))
            .foregroundStyle(SessionsTheme.lime)
            .frame(width: 184)
            .position(x: 92, y: 18)

          content
        }
      }
    }
    .background(Color.black.ignoresSafeArea())
    .dynamicTypeSize(.xSmall ... .medium)
    .task {
      await viewModel.loadWorkoutPlans()
      selectedPlanID = selectedPlanID ?? viewModel.workoutPlans.first?.id
    }
    .refreshable {
      await viewModel.loadWorkoutPlans(forceRefresh: true)
      if !viewModel.workoutPlans.contains(where: { $0.id == selectedPlanID }) {
        selectedPlanID = viewModel.workoutPlans.first?.id
      }
    }
  }

  @ViewBuilder
  private var content: some View {
    if viewModel.isLoadingWorkoutPlans && viewModel.workoutPlans.isEmpty {
      ProgressView()
        .tint(SessionsTheme.lime)
        .position(x: 92, y: 112)
    } else if viewModel.workoutPlans.isEmpty {
      VStack(spacing: 7) {
        Image(systemName: "dumbbell")
          .foregroundStyle(SessionsTheme.lime)
        Text(viewModel.workoutPlansMessage ?? "No workout sessions available")
          .font(.system(size: 7, weight: .medium))
          .foregroundStyle(SessionsTheme.muted)
          .multilineTextAlignment(.center)
      }
      .frame(width: 145)
      .position(x: 92, y: 112)
    } else {
      VStack(spacing: 8) {
        ForEach(viewModel.workoutPlans) { plan in
          NavigationLink {
            WorkoutLandingView(viewModel: viewModel, plan: plan)
          } label: {
            WorkoutPlanRow(
              plan: plan,
              isSelected: selectedPlanID == plan.id
            )
          }
          .buttonStyle(.plain)
          .simultaneousGesture(
            TapGesture().onEnded {
              selectedPlanID = plan.id
              viewModel.selectWorkoutPlan(plan)
            }
          )
          .accessibilityAddTraits(selectedPlanID == plan.id ? .isSelected : [])
        }
      }
      .padding(.top, 36)
    }
  }
}

private struct WorkoutPlanRow: View {
  let plan: WatchWorkoutPlanSummary
  let isSelected: Bool

  var body: some View {
    HStack(spacing: 7) {
      Circle()
        .fill(isSelected ? SessionsTheme.selectedIcon : SessionsTheme.iconBackground)
        .frame(width: 30, height: 30)
        .overlay {
          Image(systemName: sessionIcon(for: plan.category))
            .font(.system(size: 12, weight: .bold))
            .foregroundStyle(isSelected ? .black : SessionsTheme.lime)
            .rotationEffect(plan.category.lowercased() == "strength" ? .degrees(-45) : .zero)
        }

      VStack(alignment: .leading, spacing: 4) {
        Text(plan.name)
          .font(.system(size: 9, weight: .bold))
          .foregroundStyle(isSelected ? .black : .white)
          .lineLimit(1)
          .minimumScaleFactor(0.7)

        Text(planMetadata)
          .font(.system(size: 7, weight: .regular))
          .foregroundStyle(isSelected ? SessionsTheme.selectedSubtitle : SessionsTheme.muted)
          .lineLimit(1)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      Image(systemName: "chevron.right")
        .font(.system(size: 10, weight: .bold))
        .foregroundStyle(isSelected ? .black : SessionsTheme.chevron)
        .padding(.trailing, 5)
    }
    .padding(.horizontal, 8)
    .frame(width: 168, height: 50)
    .background(
      isSelected ? SessionsTheme.lime : SessionsTheme.card,
      in: RoundedRectangle(cornerRadius: 22, style: .continuous)
    )
    .overlay {
      RoundedRectangle(cornerRadius: 22, style: .continuous)
        .stroke(isSelected ? Color.clear : SessionsTheme.border, lineWidth: 1)
    }
    .shadow(
      color: isSelected ? SessionsTheme.lime.opacity(0.42) : .clear,
      radius: 8,
      y: 1
    )
  }

  private var planMetadata: String {
    let duration = plan.durationMinutes.map { "\($0) min" } ?? "-- min"
    return "\(plan.difficulty.capitalized) • \(duration)"
  }
}

private func sessionIcon(for category: String) -> String {
  switch category.lowercased() {
  case "strength": return "dumbbell"
  case "yoga": return "figure.mind.and.body"
  case "hiit", "cardio": return "waveform.path.ecg"
  default: return "figure.run"
  }
}

private struct SessionsDesignCanvas<Content: View>: View {
  let height: CGFloat
  let content: Content

  init(height: CGFloat, @ViewBuilder content: () -> Content) {
    self.height = height
    self.content = content()
  }

  var body: some View {
    GeometryReader { geometry in
      let scale = min(geometry.size.width / 184, 1)
      content
        .frame(width: 184, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .scaleEffect(scale, anchor: .top)
        .frame(width: geometry.size.width, height: height * scale, alignment: .top)
    }
    .frame(height: height)
  }
}

private enum SessionsTheme {
  static let lime = Color(red: 212 / 255, green: 1, blue: 0)
  static let background = Color(red: 15 / 255, green: 15 / 255, blue: 15 / 255)
  static let card = Color(red: 24 / 255, green: 24 / 255, blue: 27 / 255)
  static let border = Color(red: 39 / 255, green: 39 / 255, blue: 42 / 255)
  static let iconBackground = Color(red: 37 / 255, green: 43 / 255, blue: 31 / 255)
  static let selectedIcon = Color(red: 196 / 255, green: 1, blue: 0)
  static let selectedSubtitle = Color(red: 103 / 255, green: 103 / 255, blue: 110 / 255)
  static let muted = Color(red: 161 / 255, green: 161 / 255, blue: 170 / 255)
  static let chevron = Color(red: 82 / 255, green: 82 / 255, blue: 91 / 255)
}
