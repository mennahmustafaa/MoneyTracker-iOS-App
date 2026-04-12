//
//  SignInView.swift
//  MoneyTracker
//

import SwiftUI

@MainActor
struct SignInView: View {
    @StateObject private var viewModel: SignInViewModel

    @FocusState private var focusedField: Field?

    private enum Field {
        case email, password
    }

    init(session: SessionViewModel, onSignUp: @escaping () -> Void = {}) {
        _viewModel = StateObject(wrappedValue: SignInViewModel(session: session, onSignUp: onSignUp))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                logoSection
                    .padding(.top, 24)
                headerSection
                    .padding(.top, 28)
                formCard
                    .padding(.top, 28)
                forgotPasswordButton
                    .padding(.top, 16)
                signInButton
                    .padding(.top, 24)
                orDivider
                    .padding(.top, 28)
                googleButton
                    .padding(.top, 20)
                signUpFooter
                    .padding(.top, 32)
                    .padding(.bottom, 32)
            }
            .padding(.horizontal, 24)
        }
        .background(Color.appBackground)
    }

    private var logoSection: some View {
        Image("logo")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .shadow(color: .black.opacity(0.12), radius: 20, x: 0, y: 8)
            .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Welcome Back")
                .font(.inter(size: 28, weight: .semibold))
                .foregroundColor(Color.signInTitle)
            Text("Sign in to continue")
                .font(.inter(size: 16))
                .foregroundColor(Color.signInMuted)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private var formCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Email")
                    .font(.inter(size: 14))
                    .foregroundColor(Color.signInMuted)
                TextField("", text: $viewModel.email, prompt: Text("Enter your Email").foregroundColor(Color.signInPlaceholder))
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
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 12)

            Divider()
                .background(Color.signInFieldBorder)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Password")
                        .font(.inter(size: 14))
                        .foregroundColor(Color.signInMuted)
                    Spacer()
                    Button {
                        viewModel.togglePasswordVisibility()
                    } label: {
                        Text(viewModel.showPassword ? "Hide" : "Show")
                            .font(.inter(size: 14))
                            .foregroundColor(Color.signInMuted)
                    }
                    .buttonStyle(.plain)
                }
                Group {
                    if viewModel.showPassword {
                        TextField("", text: $viewModel.password, prompt: Text("Enter password").foregroundColor(Color.signInPlaceholder))
                            .font(.inter(size: 16))
                            .foregroundColor(Color.signInTitle)
                            .textContentType(.password)
                            .focused($focusedField, equals: .password)
                            .submitLabel(.go)
                            .onSubmit { viewModel.signIn() }
                    } else {
                        SecureField("", text: $viewModel.password, prompt: Text("Enter password").foregroundColor(Color.signInPlaceholder))
                            .font(.inter(size: 16))
                            .foregroundColor(Color.signInTitle)
                            .textContentType(.password)
                            .focused($focusedField, equals: .password)
                            .submitLabel(.go)
                            .onSubmit { viewModel.signIn() }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 14)
        }
        .background(Color.tabBarBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .inset(by: 0.75)
                .stroke(Color.signInFieldBorder, lineWidth: 1.5)
        )
    }

    private var forgotPasswordButton: some View {
        Button {
            viewModel.forgotPassword()
        } label: {
            Text("Forgot Password?")
                .font(.inter(size: 16))
                .foregroundColor(Color.signInTitle)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }

    private var signInButton: some View {
        Button {
            guard viewModel.canSubmit else { return }
            viewModel.signIn()
        } label: {
            Text("Sign In")
                .font(.inter(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.black)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
     //   .opacity(viewModel.canSubmit ? 1 : 0.45)
      // .allowsHitTesting(viewModel.canSubmit)
        .shadow(color: .black.opacity(0.14), radius: 12, x: 0, y: 10)
    }

    private var orDivider: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(Color.signInFieldBorder)
                .frame(height: 1)
            Text("or")
                .font(.inter(size: 14))
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
            HStack(spacing: 12) {
                googleMark
                Text("Continue with Google")
                    .font(.inter(size: 16, weight: .medium))
                    .foregroundColor(Color.signInTitle)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
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

    private var googleMark: some View {
        Image("GoogleIcon")
            .resizable()
            .renderingMode(.original)
            .scaledToFit()
            .frame(width: 20, height: 20)
    }

    private var signUpFooter: some View {
        HStack(spacing: 2) {
            Text("Don't have an account? ")
                .font(.inter(size: 16))
                .foregroundColor(Color.signInMuted)
            Button {
                viewModel.signUp()
            } label: {
                Text("Sign Up")
                    .font(.inter(size: 16, weight: .semibold))
                    .foregroundColor(Color.signInTitle)
            }
            .buttonStyle(.plain)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SignInView(session: SessionViewModel())
}
