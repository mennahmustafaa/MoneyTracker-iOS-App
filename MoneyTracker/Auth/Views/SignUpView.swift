//
//  SignUpView.swift
//  MoneyTracker
//

import SwiftUI

@MainActor
struct SignUpView: View {
    @StateObject private var viewModel: SignUpViewModel
    let onBack: () -> Void

    @FocusState private var focusedField: Field?

    private enum Field {
        case fullName, email, password, confirmPassword
    }

    init(session: SessionViewModel, onBack: @escaping () -> Void) {
        self.onBack = onBack
        _viewModel = StateObject(wrappedValue: SignUpViewModel(session: session))
    }

    var body: some View {
        VStack(spacing: 0) {
            backRow
            logoSection
                .padding(.top, 6)
            headerSection
                .padding(.top, 10)
            formCard
                .padding(.top, 12)
            createAccountButton
                .padding(.top, 14)
            orDivider
                .padding(.top, 14)
            googleButton
                .padding(.top, 12)
            signInFooter
                .padding(.top, 16)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .padding(.top, 6)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.white)
    }

    private var backRow: some View {
        HStack {
            Button(action: onBack) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                    Text("Back")
                        .font(.inter(size: 17))
                }
                .foregroundColor(Color.signInTitle)
            }
            .buttonStyle(.plain)
            Spacer()
        }
    }

    private var logoSection: some View {
        Image("logo")
            .resizable()
            .scaledToFit()
            .frame(width: 72, height: 72)
            .frame(maxWidth: .infinity)
            .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
    }

    private var headerSection: some View {
        VStack(spacing: 4) {
            Text("Create Account")
                .font(.inter(size: 24, weight: .semibold))
                .foregroundColor(Color.signInTitle)
            Text("Join us to start tracking")
                .font(.inter(size: 15))
                .foregroundColor(Color.signInMuted)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private var formCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            nameField
            Divider().background(Color.signInFieldBorder)
            emailField
            Divider().background(Color.signInFieldBorder)
            passwordFieldBlock
            Divider().background(Color.signInFieldBorder)
            confirmPasswordBlock
        }
        .background(Color.tabBarBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .inset(by: 0.75)
                .stroke(Color.signInFieldBorder, lineWidth: 1.5)
        )
    }

    private var nameField: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Full Name")
                .font(.inter(size: 13))
                .foregroundColor(Color.signInMuted)
            TextField("", text: $viewModel.fullName, prompt: Text("John Doe").foregroundColor(Color.signInPlaceholder))
                .font(.inter(size: 16))
                .foregroundColor(Color.signInTitle)
                .textContentType(.name)
                .textInputAutocapitalization(.words)
                .focused($focusedField, equals: .fullName)
                .submitLabel(.next)
                .onSubmit { focusedField = .email }
        }
        .padding(.horizontal, 14)
        .padding(.top, 10)
        .padding(.bottom, 8)
    }

    private var emailField: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Email")
                .font(.inter(size: 13))
                .foregroundColor(Color.signInMuted)
            TextField("", text: $viewModel.email, prompt: Text("your@email.com").foregroundColor(Color.signInPlaceholder))
                .font(.inter(size: 16))
                .foregroundColor(Color.signInTitle)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit { focusedField = .password }
        }
        .padding(.horizontal, 14)
        .padding(.top, 10)
        .padding(.bottom, 8)
    }

    private var passwordFieldBlock: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Password")
                    .font(.inter(size: 13))
                    .foregroundColor(Color.signInMuted)
                Spacer()
                Button {
                    viewModel.togglePasswordVisibility()
                } label: {
                    Text(viewModel.showPassword ? "Hide" : "Show")
                        .font(.inter(size: 13))
                        .foregroundColor(Color.signInMuted)
                }
                .buttonStyle(.plain)
            }
            if viewModel.showPassword {
                TextField("", text: $viewModel.password, prompt: Text("Enter password").foregroundColor(Color.signInPlaceholder))
                    .font(.inter(size: 16))
                    .foregroundColor(Color.signInTitle)
                    .textContentType(.newPassword)
                    .focused($focusedField, equals: .password)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .confirmPassword }
            } else {
                SecureField("", text: $viewModel.password, prompt: Text("Enter password").foregroundColor(Color.signInPlaceholder))
                    .font(.inter(size: 16))
                    .foregroundColor(Color.signInTitle)
                    .textContentType(.newPassword)
                    .focused($focusedField, equals: .password)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .confirmPassword }
            }
        }
        .padding(.horizontal, 14)
        .padding(.top, 8)
        .padding(.bottom, 8)
    }

    private var confirmPasswordBlock: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Confirm Password")
                .font(.inter(size: 13))
                .foregroundColor(Color.signInMuted)
            SecureField("", text: $viewModel.confirmPassword, prompt: Text("Re-enter password").foregroundColor(Color.signInPlaceholder))
                .font(.inter(size: 16))
                .foregroundColor(Color.signInTitle)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .confirmPassword)
                .submitLabel(.go)
                .onSubmit { viewModel.createAccount() }
        }
        .padding(.horizontal, 14)
        .padding(.top, 8)
        .padding(.bottom, 10)
    }

    private var createAccountButton: some View {
        Button {
            guard viewModel.canSubmit else { return }
            viewModel.createAccount()
        } label: {
            Text("Create Account")
                .font(.inter(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.black)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .opacity(viewModel.canSubmit ? 1 : 0.45)
        .allowsHitTesting(viewModel.canSubmit)
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 6)
    }

    private var orDivider: some View {
        HStack(spacing: 10) {
            Rectangle()
                .fill(Color.signInFieldBorder)
                .frame(height: 1)
            Text("or")
                .font(.inter(size: 13))
                .foregroundColor(Color.signInOrText)
            Rectangle()
                .fill(Color.signInFieldBorder)
                .frame(height: 1)
        }
    }

    private var googleButton: some View {
        Button {
            viewModel.continueWithGoogle()
        } label: {
            HStack(spacing: 10) {
                Image("GoogleIcon")
                    .resizable()
                    .renderingMode(.original)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text("Continue with Google")
                    .font(.inter(size: 16, weight: .medium))
                    .foregroundColor(Color.signInTitle)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.tabBarBackground)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .inset(by: 0.75)
                    .stroke(Color.signInFieldBorder, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }

    private var signInFooter: some View {
        HStack(spacing: 2) {
            Text("Already have an account? ")
                .font(.inter(size: 15))
                .foregroundColor(Color.signInMuted)
            Button(action: onBack) {
                Text("Sign In")
                    .font(.inter(size: 15, weight: .semibold))
                    .foregroundColor(Color.signInTitle)
            }
            .buttonStyle(.plain)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SignUpView(session: SessionViewModel(), onBack: {})
}
