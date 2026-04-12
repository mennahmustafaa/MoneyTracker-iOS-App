//
//  OnboardingViewModel.swift
//  MoneyTracker
//

import Combine
import Foundation

struct OnboardingFeature: Identifiable {
    let id = UUID()
    let title: String
    let assetName: String
    /// Slightly different gradient end for visual variety (matches design export).
    let useAltIconGradient: Bool

    init(title: String, assetName: String, useAltIconGradient: Bool = false) {
        self.title = title
        self.assetName = assetName
        self.useAltIconGradient = useAltIconGradient
    }
}

@MainActor
/// First-launch onboarding; completion is stored in `UserDefaults`.
final class OnboardingViewModel: ObservableObject {
    private enum Keys {
        static let completed = "hasCompletedOnboarding"
    }

    @Published private(set) var hasCompletedOnboarding: Bool

    let features: [OnboardingFeature] = [
        OnboardingFeature(title: "Shopping", assetName: "shopIcon"),
        OnboardingFeature(title: "Donation", assetName: "heartIconn"),
        OnboardingFeature(title: "Goals", assetName: "goalIcon", useAltIconGradient: true),
        OnboardingFeature(title: "Travel", assetName: "travelIcon", useAltIconGradient: true)
    ]

    let benefitLines: [String] = [
        "Track expenses effortlessly",
        "Set and achieve savings goals",
        "Make every dollar count"
    ]

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.hasCompletedOnboarding = userDefaults.bool(forKey: Keys.completed)
    }

    func completeOnboarding() {
        userDefaults.set(true, forKey: Keys.completed)
        hasCompletedOnboarding = true
    }

    /// Clears the completed flag (e.g. Profile → Log out) so onboarding shows again.
    func resetOnboarding() {
        userDefaults.set(false, forKey: Keys.completed)
        hasCompletedOnboarding = false
    }
}
