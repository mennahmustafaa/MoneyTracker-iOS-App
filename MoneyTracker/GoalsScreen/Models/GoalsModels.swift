//
//  GoalsModels.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import Foundation

/// Rich goal card model: amounts, deadline copy, and progress (Goals tab).
struct GoalProgressItem: Identifiable, Codable {
    let id: UUID
    let icon: String
    let title: String
    let deadlineText: String
    let currentAmount: Double
    let targetAmount: Double

    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return min(currentAmount / targetAmount, 1)
    }

    var progressPercent: Int {
        Int(progress * 100)
    }

    var remainingAmount: Double {
        max(targetAmount - currentAmount, 0)
    }

    init(
        id: UUID = UUID(),
        icon: String,
        title: String,
        deadlineText: String,
        currentAmount: Double,
        targetAmount: Double
    ) {
        self.id = id
        self.icon = icon
        self.title = title
        self.deadlineText = deadlineText
        self.currentAmount = currentAmount
        self.targetAmount = targetAmount
    }
}
