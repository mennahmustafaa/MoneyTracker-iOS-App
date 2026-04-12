//
//  SessionViewModel.swift
//  MoneyTracker
//

import Auth
import Combine
import Foundation
import Supabase

@MainActor
/// Email/password auth via Supabase; session persisted by the SDK (Keychain).
final class SessionViewModel: ObservableObject {
    enum DialogKind {
        case success
        case failure
        case information
    }

    struct AuthDialog: Identifiable {
        let id = UUID()
        let kind: DialogKind
        let title: String
        let message: String
    }

    private let supabase: SupabaseClient

    @Published private(set) var isSignedIn: Bool
    @Published var authDialog: AuthDialog?

    /// `true` when no anon key is configured (see `SupabaseConfig`).
    @Published private(set) var isSupabaseMisconfigured: Bool

    /// Signed-in user email (Profile header).
    @Published private(set) var profileEmail: String = ""
    /// `full_name` from signup metadata; empty if missing.
    @Published private(set) var profileFullName: String = ""

    /// When true, auth state stream does not set `isSignedIn` for sign-in events until the user dismisses a success alert.
    private var awaitingSignedInAcknowledgement = false

    init(supabase: SupabaseClient = SupabaseManager.shared) {
        self.supabase = supabase
        let keyMissing = SupabaseConfig.supabaseAnonKey.isEmpty
        self.isSupabaseMisconfigured = keyMissing
        self.isSignedIn = false
        if !keyMissing {
            Task { @MainActor [weak self] in
                guard let self else { return }
                await self.observeAuthState()
            }
        }
    }

    func clearDialog() {
        let shouldCompleteSignIn = awaitingSignedInAcknowledgement
        awaitingSignedInAcknowledgement = false
        authDialog = nil
        if shouldCompleteSignIn {
            isSignedIn = true
            Task { @MainActor in
                await refreshProfileFromCurrentSession()
            }
        }
    }

    /// Loads email + `full_name` from the current session (e.g. after the sign-in success alert).
    private func refreshProfileFromCurrentSession() async {
        guard !isSupabaseMisconfigured else { return }
        do {
            let session = try await supabase.auth.session
            updateProfileFromSession(session)
        } catch {
            updateProfileFromSession(nil)
        }
    }

    private func updateProfileFromSession(_ session: Session?) {
        guard let session else {
            if profileEmail.isEmpty, profileFullName.isEmpty { return }
            profileEmail = ""
            profileFullName = ""
            return
        }
        let user = session.user
        let newEmail = user.email ?? ""
        let newName = Self.fullNameFromUserMetadata(user) ?? ""
        if newEmail == profileEmail, newName == profileFullName { return }
        profileEmail = newEmail
        profileFullName = newName
    }

    private static func fullNameFromUserMetadata(_ user: User) -> String? {
        guard let json = user.userMetadata["full_name"] else { return nil }
        if case let .string(s) = json {
            let trimmed = s.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? nil : trimmed
        }
        return nil
    }

    func promptForgotPasswordEmail() {
        authDialog = AuthDialog(
            kind: .information,
            title: AuthAlertCopy.ForgotPassword.needEmailTitle,
            message: AuthAlertCopy.ForgotPassword.needEmailMessage
        )
    }

    func signInWithEmail(_ email: String, password: String) async {
        guard !isSupabaseMisconfigured else {
            authDialog = AuthDialog(
                kind: .information,
                title: AuthAlertCopy.Configuration.title,
                message: AuthAlertCopy.Configuration.message
            )
            return
        }
        awaitingSignedInAcknowledgement = true
        do {
            try await supabase.auth.signIn(email: email, password: password)
            authDialog = AuthDialog(
                kind: .success,
                title: AuthAlertCopy.SignIn.successTitle,
                message: AuthAlertCopy.SignIn.successMessage
            )
        } catch {
            awaitingSignedInAcknowledgement = false
            authDialog = AuthDialog(
                kind: .failure,
                title: AuthAlertCopy.SignIn.failureTitle,
                message: AuthAlertCopy.userSafeMessage(for: error)
            )
        }
    }

    func signUpWithEmail(fullName: String, email: String, password: String) async {
        guard !isSupabaseMisconfigured else {
            authDialog = AuthDialog(
                kind: .information,
                title: AuthAlertCopy.Configuration.title,
                message: AuthAlertCopy.Configuration.message
            )
            return
        }
        awaitingSignedInAcknowledgement = true
        do {
            let response = try await supabase.auth.signUp(
                email: email,
                password: password,
                data: ["full_name": .string(fullName)]
            )
            if response.session != nil {
                authDialog = AuthDialog(
                    kind: .success,
                    title: AuthAlertCopy.SignUp.successTitle,
                    message: AuthAlertCopy.SignUp.successMessageSession
                )
            } else {
                awaitingSignedInAcknowledgement = false
                authDialog = AuthDialog(
                    kind: .information,
                    title: AuthAlertCopy.SignUp.confirmEmailTitle,
                    message: AuthAlertCopy.SignUp.confirmEmailMessage
                )
            }
        } catch {
            awaitingSignedInAcknowledgement = false
            authDialog = AuthDialog(
                kind: .failure,
                title: AuthAlertCopy.SignUp.failureTitle,
                message: AuthAlertCopy.userSafeMessage(for: error)
            )
        }
    }

    func resetPassword(email: String) async {
        guard !isSupabaseMisconfigured else { return }
        do {
            try await supabase.auth.resetPasswordForEmail(email)
            authDialog = AuthDialog(
                kind: .information,
                title: AuthAlertCopy.PasswordReset.successTitle,
                message: AuthAlertCopy.PasswordReset.successMessage
            )
        } catch {
            authDialog = AuthDialog(
                kind: .failure,
                title: AuthAlertCopy.PasswordReset.failureTitle,
                message: AuthAlertCopy.userSafeMessage(for: error)
            )
        }
    }

    func signOut() {
        guard !isSupabaseMisconfigured else {
            isSignedIn = false
            updateProfileFromSession(nil)
            return
        }
        awaitingSignedInAcknowledgement = false
        Task { @MainActor in
            try? await supabase.auth.signOut()
            isSignedIn = false
            updateProfileFromSession(nil)
        }
    }

    func signInWithGoogle() {
        authDialog = AuthDialog(
            kind: .information,
            title: AuthAlertCopy.Google.title,
            message: AuthAlertCopy.Google.message
        )
    }

    private func observeAuthState() async {
        for await (event, authSession) in supabase.auth.authStateChanges {
            await MainActor.run {
                switch event {
                case .signedOut, .userDeleted:
                    awaitingSignedInAcknowledgement = false
                    isSignedIn = false
                    updateProfileFromSession(nil)
                case .initialSession:
                    if let authSession {
                        updateProfileFromSession(authSession)
                    } else {
                        updateProfileFromSession(nil)
                    }
                    if !awaitingSignedInAcknowledgement {
                        isSignedIn = authSession != nil
                    }
                case .signedIn, .tokenRefreshed:
                    if let authSession {
                        updateProfileFromSession(authSession)
                    } else {
                        updateProfileFromSession(nil)
                    }
                    if awaitingSignedInAcknowledgement {
                        break
                    }
                    isSignedIn = authSession != nil
                case .userUpdated, .passwordRecovery, .mfaChallengeVerified:
                    if let authSession {
                        updateProfileFromSession(authSession)
                    }
                    if !awaitingSignedInAcknowledgement, authSession != nil {
                        isSignedIn = true
                    }
                }
            }
        }
    }
}
