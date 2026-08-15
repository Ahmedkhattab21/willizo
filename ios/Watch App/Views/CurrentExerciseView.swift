import SwiftUI

struct CurrentExerciseView: View {
  @ObservedObject var viewModel: WorkoutViewModel

  var body: some View {
    Group {
      if viewModel.session.status == .finished {
        finishedContent
      } else if viewModel.session.status == .resting {
        RestTimerView(viewModel: viewModel)
      } else if let exercise = viewModel.currentExercise {
        exerciseContent(exercise)
      } else {
        finishedContent
      }
    }
    .navigationTitle("Workout")
  }

  private func exerciseContent(_ exercise: WatchExercise) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      ProgressView(value: viewModel.progressValue)

      Text(exercise.name.isEmpty ? "Exercise" : exercise.name)
        .font(.headline)
        .lineLimit(2)

      HStack {
        metric(title: "Set", value: "\(viewModel.currentSetNumber)/\(exercise.safeSetCount)")
        metric(title: "Reps", value: "\(exercise.reps)")
        metric(title: "Weight", value: weightText(exercise.weight))
      }

      if let previousSet = exercise.previousSet {
        Text("Previous: \(previousText(previousSet))")
          .font(.caption2)
          .foregroundStyle(.secondary)
          .lineLimit(1)
      }

      if let next = viewModel.nextExercise {
        Text("Next: \(next.name)")
          .font(.caption2)
          .foregroundStyle(.secondary)
          .lineLimit(1)
      }

      Spacer(minLength: 2)

      Button {
        viewModel.completeCurrentSet()
      } label: {
        Label("Complete Set", systemImage: "checkmark")
      }
      .buttonStyle(.borderedProminent)

      HStack {
        pauseResumeButton
        Button(role: .destructive) {
          viewModel.finishWorkout()
        } label: {
          Image(systemName: "stop.fill")
        }
        .accessibilityLabel("Finish workout")
      }
    }
  }

  private var pauseResumeButton: some View {
    Button {
      if viewModel.session.status == .paused {
        viewModel.resumeWorkout()
      } else {
        viewModel.pauseWorkout()
      }
    } label: {
      Image(systemName: viewModel.session.status == .paused ? "play.fill" : "pause.fill")
    }
    .accessibilityLabel(viewModel.session.status == .paused ? "Resume workout" : "Pause workout")
  }

  private var finishedContent: some View {
    VStack(spacing: 8) {
      Text("Workout Finished")
        .font(.headline)
      Text(viewModel.syncMessage ?? "Result queued")
        .font(.caption)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
      Button("Done") {
        viewModel.resetWorkout()
      }
    }
  }

  private func metric(title: String, value: String) -> some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(title)
        .font(.caption2)
        .foregroundStyle(.secondary)
      Text(value)
        .font(.caption)
        .fontWeight(.semibold)
        .lineLimit(1)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  private func weightText(_ weight: Double?) -> String {
    guard let weight else { return "-" }
    return String(format: "%.0f", weight)
  }

  private func previousText(_ previousSet: PreviousSet) -> String {
    let reps = previousSet.reps.map { "\($0) reps" } ?? "-"
    let weight = previousSet.weight.map { String(format: "%.0f", $0) } ?? "-"
    return "\(reps), \(weight)"
  }
}
