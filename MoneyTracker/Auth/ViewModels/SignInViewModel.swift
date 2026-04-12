//
//  SignInViewModel.swift
//  MoneyTracker
//

import Combine
import Foundation

@MainActor
/// Sign-in form → `SessionViewModel` + Supabase Auth.
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
        let mail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        Task {
            await session.signInWithEmail(mail, password: password)
        }
    }

    func continueWithGoogle() {
        session.signInWithGoogle()
    }

    func forgotPassword() {
        let mail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !mail.isEmpty else {
            session.promptForgotPasswordEmail()
            return
        }
        Task {
            await session.resetPassword(email: mail)
        }
    }

    func signUp() {
        onSignUp()
    }
}
