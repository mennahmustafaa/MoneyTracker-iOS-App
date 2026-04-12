//
//  ContentView.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI

/// App root: splash → onboarding on every cold launch → sign in → main tabs. Profile **Log out** returns to sign in.
@MainActor
struct ContentView: View {
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @StateObject private var sessionViewModel = SessionViewModel()
    @State private var showOnboarding = true
    @State private var showSignUp = false
    @State private var showSplash = true

    var body: some View {
        ZStack {
            rootContent

            if showSplash {
                SplashScreenView {
                    showSplash = false
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .animation(.easeOut(duration: 0.25), value: showSplash)
    }

    @ViewBuilder
    private var rootContent: some View {
        Group {
            if showOnboarding {
                OnboardingView(viewModel: onboardingViewModel) {
                    showOnboarding = false
                }
            } else if !sessionViewModel.isSignedIn {
                if showSignUp {
                    SignUpView(session: sessionViewModel) {
                        showSignUp = false
                    }
                } else {
                    SignInView(session: sessionViewModel) {
                        showSignUp = true
                    }
                }
            } else {
                MainTabContainerView(onLogout: {
                    sessionViewModel.signOut()
                    showSignUp = false
                })
            }
        }
    }
}

#Preview {
    ContentView()
}
