import Foundation

final class WatchWorkoutStore {
  private enum Keys {
    static let todayWorkout = "watch.todayWorkout"
    static let pendingWorkoutResults = "watch.pendingWorkoutResults"
    static let lastSyncError = "watch.lastSyncError"
  }

  private let defaults: UserDefaults

  init(defaults: UserDefaults = .standard) {
    self.defaults = defaults
  }

  func saveTodayWorkout(_ payload: [String: Any]) {
    defaults.set(payload, forKey: Keys.todayWorkout)
  }

  func todayWorkout() -> [String: Any]? {
    defaults.dictionary(forKey: Keys.todayWorkout)
  }

  func appendPendingWorkoutResult(_ payload: [String: Any]) {
    var results = pendingWorkoutResults()
    results.append(payload)
    defaults.set(results, forKey: Keys.pendingWorkoutResults)
  }

  func pendingWorkoutResults() -> [[String: Any]] {
    defaults.array(forKey: Keys.pendingWorkoutResults) as? [[String: Any]] ?? []
  }

  func clearPendingWorkoutResults() {
    defaults.removeObject(forKey: Keys.pendingWorkoutResults)
  }

  func saveLastSyncError(_ message: String) {
    defaults.set(message, forKey: Keys.lastSyncError)
  }

  func lastSyncError() -> String? {
    defaults.string(forKey: Keys.lastSyncError)
  }

  func clearPrivateData() {
    defaults.removeObject(forKey: Keys.todayWorkout)
    defaults.removeObject(forKey: Keys.pendingWorkoutResults)
    defaults.removeObject(forKey: Keys.lastSyncError)
  }
}

enum PropertyListSanitizer {
  static func sanitizeDictionary(_ dictionary: [String: Any]) -> [String: Any] {
    dictionary.reduce(into: [String: Any]()) { result, entry in
      if let value = sanitize(entry.value) {
        result[entry.key] = value
      }
    }
  }

  private static func sanitize(_ value: Any) -> Any? {
    if value is NSNull {
      return nil
    }

    switch value {
    case let dictionary as [String: Any]:
      return sanitizeDictionary(dictionary)
    case let array as [Any]:
      return array.compactMap(sanitize)
    case let string as String:
      return string
    case let number as NSNumber:
      return number
    case let date as Date:
      return date
    default:
      return "\(value)"
    }
  }
}
