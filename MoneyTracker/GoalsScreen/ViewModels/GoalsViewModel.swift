//
//  GoalsViewModel.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import Combine
import Foundation

@MainActor
/// Goals tab: list of `GoalProgressItem` cards (sample data by default).
final class GoalsViewModel: ObservableObject {
    @Published var goals: [GoalProgressItem]

    init(goals: [GoalProgressItem]? = nil) {
        self.goals = goals ?? Self.defaultGoals
    }

    // MARK: - Sample data

    private static let defaultGoals: [GoalProgressItem] = [
        GoalProgressItem(
            icon: "✈️",
            title: "Trip to Japan",
            deadlineText: "Deadline passed",
            currentAmount: 1200,
            targetAmount: 3000
        ),
        GoalProgressItem(
            icon: "💻",
            title: "New Laptop",
            deadlineText: "Deadline passed",
            currentAmount: 800,
            targetAmount: 1500
        ),
        GoalProgressItem(
            icon: "🛡️",
            title: "Emergency Fund",
            deadlineText: "7 days remaining",
            currentAmount: 5500,
            targetAmount: 10000
        )
    ]
}
