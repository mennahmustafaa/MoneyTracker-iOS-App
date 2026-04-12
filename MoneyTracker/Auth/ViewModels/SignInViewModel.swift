//
//  SignInViewModel.swift
//  MoneyTracker
//

import Combine
import Foundation

@MainActor
/// Sign-in form state and actions. Demo sign-in accepts any non-empty email + password.
final class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showPassword: Bool = false

    private let session: SessionViewModel
    private let onSignUp: () -> Void

    init(session: SessionViewModel, onSignUp: @escaping () -> Void = {}) {
        self.session = session
        self.onSignUp = onSignUp
    }

    var canSubmit: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !password.isEmpty
    }

    func togglePasswordVisibility() {
        showPassword.toggle()
    }

    func signIn() {
        guard canSubmit else { return }
        session.signIn()
    }

    func continueWithGoogle() {
        session.signIn()
    }

    func forgotPassword() {}

    func signUp() {
        onSignUp()
    }
}
