import Foundation

final class WatchWorkoutStore {
  private enum Keys {
    static let snapshot = "watch.snapshot"
    static let session = "watch.session"
    static let unsyncedResults = "watch.unsyncedResults"
  }

  private let defaults: UserDefaults
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()

  init(defaults: UserDefaults = .standard) {
    self.defaults = defaults
  }

  func saveSnapshot(_ snapshot: WatchWorkoutSnapshot) {
    encode(snapshot, key: Keys.snapshot)
  }

  func loadSnapshot() -> WatchWorkoutSnapshot? {
    decode(WatchWorkoutSnapshot.self, key: Keys.snapshot)
  }

  func saveSession(_ session: WorkoutSessionState) {
    encode(session, key: Keys.session)
  }

  func loadSession() -> WorkoutSessionState {
    decode(WorkoutSessionState.self, key: Keys.session) ?? .empty
  }

  func clearSession() {
    defaults.removeObject(forKey: Keys.session)
  }

  func clearPrivateData() {
    defaults.removeObject(forKey: Keys.snapshot)
    defaults.removeObject(forKey: Keys.session)
    defaults.removeObject(forKey: Keys.unsyncedResults)
  }

  func appendUnsyncedResult(_ result: WorkoutResultPayload) {
    var results = loadUnsyncedResults()
    results.append(result)
    encode(results, key: Keys.unsyncedResults)
  }

  func loadUnsyncedResults() -> [WorkoutResultPayload] {
    decode([WorkoutResultPayload].self, key: Keys.unsyncedResults) ?? []
  }

  func replaceUnsyncedResults(_ results: [WorkoutResultPayload]) {
    encode(results, key: Keys.unsyncedResults)
  }

  private func encode<T: Encodable>(_ value: T, key: String) {
    guard let data = try? encoder.encode(value) else { return }
    defaults.set(data, forKey: key)
  }

  private func decode<T: Decodable>(_ type: T.Type, key: String) -> T? {
    guard let data = defaults.data(forKey: key) else { return nil }
    return try? decoder.decode(type, from: data)
  }
}
