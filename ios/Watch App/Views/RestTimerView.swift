import SwiftUI

struct RestTimerView: View {
  @ObservedObject var viewModel: WorkoutViewModel
  @ObservedObject private var timer: RestTimerService

  init(viewModel: WorkoutViewModel) {
    self.viewModel = viewModel
    self.timer = viewModel.restTimer
  }

  var body: some View {
    VStack(spacing: 10) {
      Text("Rest")
        .font(.headline)

      Text(timeText)
        .font(.system(size: 42, weight: .bold, design: .rounded))
        .monospacedDigit()
        .minimumScaleFactor(0.6)

      if let exercise = viewModel.currentExercise,
         viewModel.currentSetNumber < exercise.safeSetCount {
        Text("Next set: \(viewModel.currentSetNumber + 1)/\(exercise.safeSetCount)")
          .font(.caption)
          .foregroundStyle(.secondary)
      } else if let next = viewModel.nextExercise {
        Text("Next: \(next.name)")
          .font(.caption)
          .foregroundStyle(.secondary)
          .lineLimit(1)
      }

      Button("Skip Rest") {
        viewModel.skipRest()
      }
    }
  }

  private var timeText: String {
    let minutes = timer.remainingSeconds / 60
    let seconds = timer.remainingSeconds % 60
    return String(format: "%d:%02d", minutes, seconds)
  }
}
