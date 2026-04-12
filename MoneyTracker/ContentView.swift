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

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// Drives lightweight transitions between onboarding, sign-in/up, and main tabs.
    private var rootPhase: Int {
        if showOnboarding { return 0 }
        if !sessionViewModel.isSignedIn { return showSignUp ? 1 : 2 }
        return 3
    }

    private var splashAnimation: Animation {
        reduceMotion ? .easeOut(duration: 0.001) : AppMotion.overlay
    }

    private var screenAnimation: Animation {
        reduceMotion ? .easeOut(duration: 0.001) : AppMotion.screenTransition
    }

    var body: some View {
        ZStack {
            rootContent
                .id(rootPhase)
                .transition(.appScreen)

            if showSplash {
                SplashScreenView {
                    showSplash = false
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .animation(screenAnimation, value: rootPhase)
        .animation(splashAnimation, value: showSplash)
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
                MainTabContainerView(session: sessionViewModel, onLogout: {
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
