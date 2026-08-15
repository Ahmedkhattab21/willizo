import Foundation

final class RestTimerService: ObservableObject {
  @Published private(set) var remainingSeconds = 0
  @Published private(set) var isRunning = false

  private var timer: Timer?
  private var onComplete: (() -> Void)?

  func start(seconds: Int, onComplete: @escaping () -> Void) {
    stop()
    remainingSeconds = max(seconds, 0)
    self.onComplete = onComplete

    guard remainingSeconds > 0 else {
      complete()
      return
    }

    isRunning = true
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
      self?.tick()
    }
  }

  func skip() {
    complete()
  }

  func stop() {
    timer?.invalidate()
    timer = nil
    isRunning = false
  }

  private func tick() {
    remainingSeconds -= 1
    if remainingSeconds <= 0 {
      complete()
    }
  }

  private func complete() {
    let completion = onComplete
    stop()
    remainingSeconds = 0
    onComplete = nil
    completion?()
  }
}
