import Flutter
import Foundation
import WatchConnectivity

final class WatchWorkoutBridge: NSObject {
  static let shared = WatchWorkoutBridge()

  private let channelName = "willizo/watch_workout"
  private let store = WatchWorkoutStore()
  private var methodChannel: FlutterMethodChannel?
  private var authSession: [String: Any]?
  private var pendingAuthClear = false

  private override init() {
    super.init()
  }

  func configure(with messenger: FlutterBinaryMessenger) {
    methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
    methodChannel?.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }

    guard WCSession.isSupported() else { return }
    WCSession.default.delegate = self
    WCSession.default.activate()
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "updateTodayWorkout":
      guard let payload = call.arguments as? [String: Any] else {
        result(FlutterError(code: "invalid_arguments", message: "Expected workout payload", details: nil))
        return
      }
      let sanitizedPayload = PropertyListSanitizer.sanitizeDictionary(payload)
      store.saveTodayWorkout(sanitizedPayload)
      sendTodayWorkoutToWatch(sanitizedPayload)
      result(nil)

    case "getPendingWorkoutResults":
      result(store.pendingWorkoutResults())

    case "clearPendingWorkoutResults":
      store.clearPendingWorkoutResults()
      result(nil)

    case "updateAuthSession":
      guard let payload = call.arguments as? [String: Any],
            payload["accessToken"] as? String != nil,
            payload["refreshToken"] as? String != nil else {
        result(FlutterError(code: "invalid_auth_session", message: "Missing auth session fields", details: nil))
        return
      }
      let sanitizedPayload = PropertyListSanitizer.sanitizeDictionary(payload)
      authSession = sanitizedPayload
      pendingAuthClear = false
      sendAuthSessionToWatch(sanitizedPayload)
      result(nil)

    case "clearAuthSession":
      clearAuthSessionOnWatch()
      result(nil)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func sendAuthSessionToWatch(_ payload: [String: Any]) {
    guard WCSession.isSupported(), WCSession.default.activationState == .activated else { return }
    let message: [String: Any] = ["type": "authSession", "payload": payload]
    if WCSession.default.isReachable {
      WCSession.default.sendMessage(message, replyHandler: nil) { [weak self] error in
        self?.store.saveLastSyncError(error.localizedDescription)
      }
    } else {
      WCSession.default.transferUserInfo(message)
    }
  }

  private func clearAuthSessionOnWatch() {
    authSession = nil
    pendingAuthClear = true
    store.clearPrivateData()
    guard WCSession.isSupported(), WCSession.default.activationState == .activated else { return }
    let message: [String: Any] = ["type": "authCleared"]
    WCSession.default.transferUserInfo(message)
    if WCSession.default.isReachable {
      WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
    }
    pendingAuthClear = false
  }

  private func replyWithAuthSession(_ replyHandler: @escaping ([String: Any]) -> Void) {
    if let authSession {
      replyHandler(["type": "authSession", "payload": authSession])
      return
    }

    DispatchQueue.main.async { [weak self] in
      guard let self, let methodChannel = self.methodChannel else {
        replyHandler(["type": "authUnavailable"])
        return
      }
      methodChannel.invokeMethod("requestAuthSession", arguments: nil) { [weak self] result in
        guard let payload = result as? [String: Any],
              payload["accessToken"] as? String != nil,
              payload["refreshToken"] as? String != nil else {
          replyHandler(["type": "authUnavailable"])
          return
        }
        let sanitized = PropertyListSanitizer.sanitizeDictionary(payload)
        self?.authSession = sanitized
        replyHandler(["type": "authSession", "payload": sanitized])
      }
    }
  }

  private func acceptAuthSessionUpdateFromWatch(_ payload: [String: Any]) {
    let sanitized = PropertyListSanitizer.sanitizeDictionary(payload)
    authSession = sanitized
    pendingAuthClear = false
    DispatchQueue.main.async { [weak self] in
      self?.methodChannel?.invokeMethod("authSessionUpdated", arguments: sanitized)
    }
  }

  private func sendTodayWorkoutToWatch(_ payload: [String: Any]) {
    guard WCSession.isSupported(), WCSession.default.activationState == .activated else {
      return
    }

    do {
      try WCSession.default.updateApplicationContext(["todayWorkout": payload])
    } catch {
      store.saveLastSyncError(error.localizedDescription)
    }

    guard WCSession.default.isReachable else { return }
    WCSession.default.sendMessage(["type": "todayWorkout", "payload": payload], replyHandler: nil) { [weak self] error in
      self?.store.saveLastSyncError(error.localizedDescription)
    }
  }

  private func handleWorkoutResult(_ resultPayload: [String: Any]) {
    let sanitizedPayload = PropertyListSanitizer.sanitizeDictionary(resultPayload)
    store.appendPendingWorkoutResult(sanitizedPayload)
    methodChannel?.invokeMethod("workoutResultReceived", arguments: sanitizedPayload)
  }

  private func replyWithCurrentWorkout(_ replyHandler: (([String: Any]) -> Void)?) {
    guard let replyHandler else { return }
    var reply: [String: Any] = ["type": "todayWorkout"]
    if let payload = store.todayWorkout() {
      reply["payload"] = payload
    }
    if let lastSyncError = store.lastSyncError() {
      reply["lastSyncError"] = lastSyncError
    }
    replyHandler(reply)
  }
}

extension WatchWorkoutBridge: WCSessionDelegate {
  func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
    if let error {
      store.saveLastSyncError(error.localizedDescription)
      return
    }

    if activationState == .activated {
      if let payload = store.todayWorkout() {
        sendTodayWorkoutToWatch(payload)
      }
      if let authSession {
        sendAuthSessionToWatch(authSession)
      } else if pendingAuthClear {
        clearAuthSessionOnWatch()
      }
    }
  }

  func sessionDidBecomeInactive(_ session: WCSession) {}

  func sessionDidDeactivate(_ session: WCSession) {
    WCSession.default.activate()
  }

  func session(
    _ session: WCSession,
    didReceiveMessage message: [String: Any],
    replyHandler: @escaping ([String: Any]) -> Void
  ) {
    let messageType = message["type"] as? String

    switch messageType {
    case "requestTodayWorkout":
      DispatchQueue.main.async { [weak self] in
        self?.methodChannel?.invokeMethod("refreshTodayWorkout", arguments: nil)
      }
      replyWithCurrentWorkout(replyHandler)

    case "requestAuthSession":
      replyWithAuthSession(replyHandler)

    case "authSessionUpdated":
      if let payload = message["payload"] as? [String: Any] {
        acceptAuthSessionUpdateFromWatch(payload)
      }
      replyHandler(["status": "accepted"])

    case "workoutResult":
      if let resultPayload = message["result"] as? [String: Any] {
        handleWorkoutResult(resultPayload)
      }
      replyHandler(["status": "queued"])

    default:
      replyHandler(["status": "ignored"])
    }
  }

  func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
    if userInfo["type"] as? String == "authSessionUpdated",
       let payload = userInfo["payload"] as? [String: Any] {
      acceptAuthSessionUpdateFromWatch(payload)
      return
    }
    guard userInfo["type"] as? String == "workoutResult",
          let resultPayload = userInfo["result"] as? [String: Any] else {
      return
    }
    handleWorkoutResult(resultPayload)
  }
}
