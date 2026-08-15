import Foundation
import Security

struct WatchAuthSession: Codable, Equatable {
  let accessToken: String
  let refreshToken: String
  let tokenType: String
  let expiresAt: Date?
  let baseURL: String

  init(
    accessToken: String,
    refreshToken: String,
    tokenType: String = "bearer",
    expiresAt: Date? = nil,
    baseURL: String = "https://willizo.com/api"
  ) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
    self.tokenType = tokenType
    self.expiresAt = expiresAt
    self.baseURL = baseURL
  }

  init?(payload: [String: Any]) {
    guard let accessToken = payload["accessToken"] as? String,
          let refreshToken = payload["refreshToken"] as? String,
          !accessToken.isEmpty,
          !refreshToken.isEmpty else {
      return nil
    }
    let expiresIn = (payload["expiresIn"] as? NSNumber)?.doubleValue
    self.init(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: payload["tokenType"] as? String ?? "bearer",
      expiresAt: expiresIn.map { Date().addingTimeInterval($0) },
      baseURL: payload["baseURL"] as? String ?? "https://willizo.com/api"
    )
  }

  var connectivityPayload: [String: Any] {
    var payload: [String: Any] = [
      "accessToken": accessToken,
      "refreshToken": refreshToken,
      "tokenType": tokenType,
      "baseURL": baseURL,
    ]
    if let expiresAt {
      payload["expiresIn"] = max(Int(expiresAt.timeIntervalSinceNow), 0)
    }
    return payload
  }
}

enum WatchAuthenticationState: Equatable {
  case connecting
  case authenticated
  case requiresPhone
}

final class WatchAuthManager: ObservableObject {
  @Published private(set) var state: WatchAuthenticationState
  private(set) var session: WatchAuthSession?

  private let keychain: WatchKeychain
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()

  init(keychain: WatchKeychain = WatchKeychain()) {
    self.keychain = keychain
    if let data = keychain.read(),
       let session = try? decoder.decode(WatchAuthSession.self, from: data) {
      self.session = session
      self.state = .authenticated
    } else {
      self.session = nil
      self.state = .connecting
    }
  }

  @discardableResult
  func accept(_ payload: [String: Any]) -> Bool {
    guard let session = WatchAuthSession(payload: payload) else { return false }
    save(session)
    return true
  }

  func save(_ session: WatchAuthSession) {
    guard let data = try? encoder.encode(session), keychain.save(data) else { return }
    self.session = session
    state = .authenticated
  }

  func markPhoneRequired() {
    guard session == nil else { return }
    state = .requiresPhone
  }

  func clear() {
    session = nil
    keychain.delete()
    state = .requiresPhone
  }
}

struct WatchKeychain {
  private let service = "com.example.willizo.watch.auth"
  private let account = "session"

  func save(_ data: Data) -> Bool {
    delete()
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
      kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
      kSecValueData as String: data,
    ]
    return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
  }

  func read() -> Data? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne,
    ]
    var item: CFTypeRef?
    guard SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess else { return nil }
    return item as? Data
  }

  func delete() {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
    ]
    SecItemDelete(query as CFDictionary)
  }
}
