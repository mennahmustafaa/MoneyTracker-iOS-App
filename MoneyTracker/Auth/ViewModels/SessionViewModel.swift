//
//  SessionViewModel.swift
//  MoneyTracker
//

import Combine
import Foundation

@MainActor
/// Persists signed-in state (demo: no real backend). Used by `ContentView` routing and `SignInViewModel`.
final class SessionViewModel: ObservableObject {
    private enum Keys {
        static let signedIn = "isUserSignedIn"
    }

    @Published private(set) var isSignedIn: Bool

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.isSignedIn = userDefaults.bool(forKey: Keys.signedIn)
    }

    func signIn() {
        userDefaults.set(true, forKey: Keys.signedIn)
        isSignedIn = true
    }

    func signOut() {
        userDefaults.set(false, forKey: Keys.signedIn)
        isSignedIn = false
    }
}
