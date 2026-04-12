//
//  AuthAlertCopy.swift
//  MoneyTracker
//

import Foundation

/// User-facing auth strings: neutral tone, no emojis, no internal error codes.
enum AuthAlertCopy {

    enum SignIn {
        static let successTitle = "Signed in"
        static let successMessage = "Logged in successfully."

        static let failureTitle = "Sign in failed"
    }

    enum SignUp {
        static let successTitle = "Account created"
        static let successMessageSession = "Your account is ready. Tap OK to continue."

        static let confirmEmailTitle = "Confirm your email"
        static let confirmEmailMessage =
            "We sent a message to your inbox. Open the link in that email to verify your account, then return here to sign in."

        static let failureTitle = "Could not create account"
    }

    enum PasswordReset {
        static let successTitle = "Email sent"
        static let successMessage =
            "If an account exists for that address, you will receive a message with reset instructions. Check your inbox and spam folder."

        static let failureTitle = "Request failed"
    }

    enum Configuration {
        static let title = "Setup required"
        static let message =
            "Add your Supabase anon key in SupabaseConfig or Info.plist (SUPABASE_ANON_KEY). See project documentation."
    }

    enum Google {
        static let title = "Google sign-in"
        static let message =
            "Use email and password for now. To use Google, enable the provider in Supabase Authentication settings and configure your app URL scheme in Xcode."
    }

    enum ForgotPassword {
        static let needEmailTitle = "Email required"
        static let needEmailMessage = "Enter your email in the field above, then tap Forgot Password again."
    }

    /// Maps transport and API errors to a short, safe message (no stack traces or raw JSON).
    static func userSafeMessage(for error: Error) -> String {
        let text = error.localizedDescription.lowercased()

        if text.contains("invalid login") || text.contains("invalid credentials") || text.contains("wrong password") {
            return "The email or password is incorrect. Try again or use Forgot Password."
        }
        if text.contains("email not confirmed") || text.contains("not confirmed") {
            return "Confirm your email address using the link we sent, then try signing in."
        }
        if text.contains("already registered") || text.contains("already been registered") {
            return "An account with this email already exists. Sign in instead."
        }
        if text.contains("password") && (text.contains("weak") || text.contains("short") || text.contains("least")) {
            return "Choose a stronger password that meets the requirements."
        }
        if text.contains("network") || text.contains("internet") || text.contains("connection") {
            return "Network error. Check your connection and try again."
        }
        if text.contains("rate limit") || text.contains("too many") {
            return "Too many attempts. Wait a few minutes, then try again."
        }

        return "Something went wrong. Check your details and try again. If it continues, try again later."
    }
}
