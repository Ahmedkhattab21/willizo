import Foundation
import WatchConnectivity

final class PhoneConnectivityService: NSObject, ObservableObject {
  @Published private(set) var isPhoneReachable = false
  @Published private(set) var lastSyncMessage: String?

  var onWorkoutSnapshotReceived: ((WatchWorkoutSnapshot) -> Void)?
  var onAuthSessionReceived: (([String: Any]) -> Void)?
  var onAuthCleared: (() -> Void)?

  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()

  override init() {
    super.init()
    guard WCSession.isSupported() else {
      lastSyncMessage = "iPhone sync unavailable"
      return
    }
    WCSession.default.delegate = self
    WCSession.default.activate()
  }

  func requestAuthSession() {
    guard WCSession.default.activationState == .activated else {
      lastSyncMessage = "Connecting to iPhone"
      return
    }
    guard WCSession.default.isReachable else {
      lastSyncMessage = "Open Willizo on your iPhone"
      return
    }
    WCSession.default.sendMessage(["type": "requestAuthSession"], replyHandler: { [weak self] reply in
      guard reply["type"] as? String == "authSession",
            let payload = reply["payload"] as? [String: Any] else {
        DispatchQueue.main.async {
          self?.lastSyncMessage = "Sign in on your iPhone first"
        }
        return
      }
      DispatchQueue.main.async {
        self?.lastSyncMessage = "Account connected"
        self?.onAuthSessionReceived?(payload)
      }
    }, errorHandler: { [weak self] error in
      DispatchQueue.main.async {
        self?.lastSyncMessage = error.localizedDescription
      }
    })
  }

  func sendAuthSessionUpdate(_ payload: [String: Any]) {
    guard WCSession.default.activationState == .activated else { return }
    let message: [String: Any] = ["type": "authSessionUpdated", "payload": payload]
    if WCSession.default.isReachable {
      WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
    } else {
      WCSession.default.transferUserInfo(message)
    }
  }

  func requestTodayWorkout(completion: ((Bool) -> Void)? = nil) {
    guard WCSession.default.activationState == .activated else {
      completion?(false)
      return
    }

    guard WCSession.default.isReachable else {
      lastSyncMessage = "Open the iPhone app to refresh"
      completion?(false)
      return
    }

    WCSession.default.sendMessage(["type": "requestTodayWorkout"], replyHandler: { [weak self] reply in
      guard let self,
            let payload = reply["payload"] as? [String: Any] else {
        DispatchQueue.main.async { completion?(false) }
        return
      }
      let didRefresh = self.decodeSnapshot(payload)
      DispatchQueue.main.async { completion?(didRefresh) }
    }, errorHandler: { [weak self] error in
      DispatchQueue.main.async {
        self?.lastSyncMessage = error.localizedDescription
        completion?(false)
      }
    })
  }

  func sendWorkoutResult(_ result: WorkoutResultPayload) -> Bool {
    guard let resultDictionary = dictionary(from: result) else {
      lastSyncMessage = "Could not encode workout result"
      return false
    }

    let message: [String: Any] = [
      "type": "workoutResult",
      "result": resultDictionary,
    ]

    guard WCSession.default.activationState == .activated else {
      lastSyncMessage = "Result saved on watch"
      return false
    }

    if WCSession.default.isReachable {
      WCSession.default.sendMessage(message, replyHandler: { [weak self] _ in
        DispatchQueue.main.async {
          self?.lastSyncMessage = "Synced with iPhone"
        }
      }, errorHandler: { [weak self] error in
        DispatchQueue.main.async {
          self?.lastSyncMessage = error.localizedDescription
        }
      })
      return true
    }

    WCSession.default.transferUserInfo(message)
    lastSyncMessage = "Queued for iPhone sync"
    return true
  }

  func retryQueuedResults(_ results: [WorkoutResultPayload]) -> [WorkoutResultPayload] {
    guard WCSession.default.activationState == .activated else {
      return results
    }

    var unsent: [WorkoutResultPayload] = []
    for result in results {
      if !sendWorkoutResult(result) {
        unsent.append(result)
      }
    }
    return unsent
  }

  @discardableResult
  private func decodeSnapshot(_ dictionary: [String: Any]) -> Bool {
    guard let data = try? JSONSerialization.data(withJSONObject: dictionary),
          let snapshot = try? decoder.decode(WatchWorkoutSnapshot.self, from: data) else {
      DispatchQueue.main.async {
        self.lastSyncMessage = "Workout data could not be read"
      }
      return false
    }

    DispatchQueue.main.async {
      self.lastSyncMessage = "Workout updated"
      self.onWorkoutSnapshotReceived?(snapshot)
    }
    return true
  }

  private func dictionary<T: Encodable>(from value: T) -> [String: Any]? {
    guard let data = try? encoder.encode(value),
          let object = try? JSONSerialization.jsonObject(with: data),
          let dictionary = object as? [String: Any] else {
      return nil
    }
    return dictionary
  }
}

extension PhoneConnectivityService: WCSessionDelegate {
  func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
    DispatchQueue.main.async {
      self.isPhoneReachable = session.isReachable
      if let error {
        self.lastSyncMessage = error.localizedDescription
      } else if activationState == .activated {
        self.requestAuthSession()
      }
    }
  }

  func sessionReachabilityDidChange(_ session: WCSession) {
    DispatchQueue.main.async {
      self.isPhoneReachable = session.isReachable
    }
  }

  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
    guard let payload = applicationContext["todayWorkout"] as? [String: Any] else { return }
    decodeSnapshot(payload)
  }

  func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
    switch message["type"] as? String {
    case "todayWorkout":
      guard let payload = message["payload"] as? [String: Any] else { return }
      decodeSnapshot(payload)
    case "authSession":
      guard let payload = message["payload"] as? [String: Any] else { return }
      DispatchQueue.main.async { self.onAuthSessionReceived?(payload) }
    case "authCleared":
      DispatchQueue.main.async { self.onAuthCleared?() }
    default:
      return
    }
  }

  func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
    switch userInfo["type"] as? String {
    case "authSession":
      guard let payload = userInfo["payload"] as? [String: Any] else { return }
      DispatchQueue.main.async { self.onAuthSessionReceived?(payload) }
    case "authCleared":
      DispatchQueue.main.async { self.onAuthCleared?() }
    default:
      return
    }
  }
}
