//
//  AppMotion.swift
//  MoneyTracker
//

import SwiftUI

/// Short, lightweight motion used app-wide. Keeps durations small to avoid jank and battery drain.
enum AppMotion {
    /// Tab switches and bar selection (snappy spring).
    static let tab: Animation = .spring(response: 0.34, dampingFraction: 0.88)

    /// Root screen changes (onboarding, auth, main shell).
    static let screenTransition: Animation = .easeOut(duration: 0.26)

    /// Splash / overlay fade.
    static let overlay: Animation = .easeOut(duration: 0.28)

    /// Subtle content cross-fade inside scroll areas.
    static let contentFade: Animation = .easeInOut(duration: 0.2)

    /// First paint on a full screen (auth, tab body): short ease-out, no continuous work.
    static let screenEnter: Animation = .easeOut(duration: 0.32)

    /// Onboarding stagger between sections.
    static let onboardingStep: Animation = .easeOut(duration: 0.38)

    /// Progress fills, budget numbers — runs only when values change, not every frame.
    static let valueChange: Animation = .easeOut(duration: 0.48)
}

extension AnyTransition {
    /// Slight scale + fade — cheap (opacity + transform only).
    static var appScreen: AnyTransition {
        .asymmetric(
            insertion: .opacity.combined(with: .scale(scale: 0.992)),
            removal: .opacity.combined(with: .scale(scale: 1.004))
        )
    }

    /// Tab body: opacity only (no scale) to keep tab switches cheap on the GPU.
    static var appTabContent: AnyTransition {
        .opacity
    }
}

// MARK: - Screen enter (lightweight)

/// Slides content up slightly on appear — opacity stays at 1 so it stacks cleanly with tab transitions.
private struct AppScreenEnterModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var entered = false

    func body(content: Content) -> some View {
        content
            .offset(y: entered ? 0 : 12)
            .onAppear {
                if reduceMotion {
                    entered = true
                } else {
                    withAnimation(AppMotion.screenEnter) {
                        entered = true
                    }
                }
            }
    }
}

extension View {
    /// Subtle upward motion when the view appears (tab screens, auth, profile). Respects Reduce Motion.
    func appScreenEnter() -> some View {
        modifier(AppScreenEnterModifier())
    }

    /// Smooth numeric/text updates for currency (only animates when `value` changes).
    func appAnimatedAmount<Value: Equatable>(value: Value) -> some View {
        self
            .contentTransition(.numericText())
            .animation(AppMotion.valueChange, value: value)
    }
}
