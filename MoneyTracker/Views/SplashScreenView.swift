//
//  SplashScreenView.swift
//  MoneyTracker
//

import SwiftUI

/// Cold-launch splash: matches onboarding (`appBackground`, logo shadows, Inter wordmark).
@MainActor
struct SplashScreenView: View {
    /// Called on the main actor after the hold + fade-out animation.
    var onFinished: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var contentVisible = false
    @State private var dismissSelf = false

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            LinearGradient(
                colors: [
                    Color.white.opacity(0.45),
                    Color.appBackground.opacity(0.3),
                    Color.appBackground
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 18) {
                Spacer(minLength: 0)

                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96, height: 96)
                    .shadow(color: .black.opacity(0.12), radius: 18, x: 0, y: 8)
                    .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
                    .scaleEffect(contentVisible ? 1 : 0.88)
                    .opacity(contentVisible ? 1 : 0)

                VStack(spacing: 10) {
                    Text("MoneyTrack")
                        .font(.inter(size: 34, weight: .bold))
                        .kerning(0.35)
                        .foregroundColor(Color.onboardingTitle)

                    Text("Where money makes sense")
                        .font(.inter(size: 17))
                        .foregroundColor(Color.onboardingSubtitle)
                        .multilineTextAlignment(.center)

                    Text("Track it. Own it.")
                        .font(.inter(size: 20, weight: .bold))
                        .foregroundColor(Color.onboardingTitle)
                        .padding(.top, 4)

                    Text("Budget, history, goals, and giving—everything you need to stay on top of your money.")
                        .font(.inter(size: 14))
                        .foregroundColor(Color.onboardingFooter)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .padding(.horizontal, 8)
                }
                .opacity(contentVisible ? 1 : 0)
                .offset(y: contentVisible ? 0 : 12)

                Spacer(minLength: 0)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 32)
        }
        .opacity(dismissSelf ? 0 : 1)
        .onAppear {
            if reduceMotion {
                contentVisible = true
            } else {
                withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
                    contentVisible = true
                }
            }
            Task {
                // Hold on screen so users can read logo + copy (~2.4s), then fade out.
                try? await Task.sleep(nanoseconds: 2_400_000_000)
                await MainActor.run {
                    if reduceMotion {
                        dismissSelf = true
                    } else {
                        withAnimation(.easeOut(duration: 0.42)) {
                            dismissSelf = true
                        }
                    }
                }
                try? await Task.sleep(nanoseconds: 450_000_000)
                await MainActor.run {
                    onFinished()
                }
            }
        }
    }
}

#Preview {
    SplashScreenView(onFinished: {})
}
