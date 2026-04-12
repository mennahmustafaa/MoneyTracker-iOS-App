//
//  ContentView.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI

/// App root: onboarding → sign in → main tabs. Profile **Log out** returns to sign in.
struct ContentView: View {
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @StateObject private var sessionViewModel = SessionViewModel()

    var body: some View {
        Group {
            if !onboardingViewModel.hasCompletedOnboarding {
                OnboardingView(viewModel: onboardingViewModel)
            } else if !sessionViewModel.isSignedIn {
                SignInView(session: sessionViewModel)
            } else {
                MainTabContainerView(onLogout: { sessionViewModel.signOut() })
            }
        }
    }
}

#Preview {
    ContentView()
}
