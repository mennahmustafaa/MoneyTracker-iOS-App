//
//  SignInView.swift
//  MoneyTracker
//

import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel: SignInViewModel

    @FocusState private var focusedField: Field?

    private enum Field {
        case email, password
    }

    init(session: SessionViewModel) {
        _viewModel = StateObject(wrappedValue: SignInViewModel(session: session))
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
            viewModel.signIn()
        } label: {
            ZStack {
                Capsule()
                    .fill(Color.signInTitle)
                Capsule()
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: .white.opacity(0), location: 0),
                                .init(color: .white.opacity(0.1), location: 0.5),
                                .init(color: .white.opacity(0), location: 1)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                Text("Sign In")
                    .font(.inter(size: 16, weight: .semibold))
                    .foregroundColor(.whiteText)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
        }
        .buttonStyle(.plain)
        .shadow(color: .black.opacity(0.14), radius: 12, x: 0, y: 10)
        .disabled(!viewModel.canSubmit)
        .opacity(viewModel.canSubmit ? 1 : 0.45)
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
                Image("GoogleIcon")
                    .resizable()
                    .renderingMode(.original)
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                Text("Continue with Google")
                    .font(.inter(size: 16, weight: .medium))
                    .foregroundColor(.whiteText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.backgroundBlack)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
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
