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
/// Static copy and feature grid for onboarding (no persistence — shown each app launch until **Get Started**).
final class OnboardingViewModel: ObservableObject {
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

    init() {}
}
