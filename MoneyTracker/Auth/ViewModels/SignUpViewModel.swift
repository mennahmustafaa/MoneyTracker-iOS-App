//
//  SignUpViewModel.swift
//  MoneyTracker
//

import Combine
import Foundation

@MainActor
/// Create-account form. Demo: signs in when fields are valid and passwords match.
final class SignUpViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var showPassword: Bool = false

    private let session: SessionViewModel

    init(session: SessionViewModel) {
        self.session = session
    }

    var canSubmit: Bool {
        let name = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        let mail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty, !mail.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            return false
        }
        return password == confirmPassword
    }

    func togglePasswordVisibility() {
        showPassword.toggle()
    }

    func createAccount() {
        guard canSubmit else { return }
        session.signIn()
    }

    func continueWithGoogle() {
        session.signIn()
    }
}
