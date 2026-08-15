import SwiftUI

@main
struct WillizoWatchApp: App {
  @StateObject private var viewModel = WorkoutViewModel()

  var body: some Scene {
    WindowGroup {
      NavigationStack {
        switch viewModel.authState {
        case .authenticated:
          TodayWorkoutView(viewModel: viewModel)
        case .connecting:
          WatchConnectionView(
            title: "Connecting",
            message: "Checking your Willizo account on iPhone",
            isLoading: true,
            retry: viewModel.requestLatestWorkout
          )
        case .requiresPhone:
          WatchConnectionView(
            title: "iPhone needed",
            message: "Open Willizo and sign in on your iPhone",
            isLoading: false,
            retry: viewModel.requestLatestWorkout
          )
        }
      }
      .toolbar(.hidden, for: .navigationBar)
      .persistentSystemOverlays(.hidden)
    }
  }
}

private struct WatchConnectionView: View {
  let title: String
  let message: String
  let isLoading: Bool
  let retry: () -> Void

  var body: some View {
    VStack(spacing: 10) {
      if isLoading {
        ProgressView()
          .tint(Color(red: 0.78, green: 1, blue: 0))
      } else {
        Image(systemName: "iphone.and.arrow.forward")
          .font(.system(size: 25, weight: .semibold))
          .foregroundStyle(Color(red: 0.78, green: 1, blue: 0))
      }
      Text(title)
        .font(.system(size: 16, weight: .bold))
      Text(message)
        .font(.system(size: 10))
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
        .lineLimit(3)
        .fixedSize(horizontal: false, vertical: true)
      Button(action: retry) {
        Image(systemName: "arrow.clockwise")
      }
      .buttonStyle(.bordered)
      .accessibilityLabel("Retry")
    }
    .padding(.horizontal, 14)
  }
}
