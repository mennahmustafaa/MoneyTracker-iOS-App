//
//  BudgetModels.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import Foundation

/// Snapshot for the home budget card: balance and income vs expense totals.
struct BudgetSummary {
    let currentBalance: Double
    let income: Double
    let expenses: Double
}

/// Planned recurring payment (e.g. rent) for upcoming-expense UI.
struct UpcomingExpense: Identifiable {
    let id: UUID
    let name: String
    let amount: Double
    let frequency: String
    let date: String

    init(id: UUID = UUID(), name: String, amount: Double, frequency: String, date: String) {
        self.id = id
        self.name = name
        self.amount = amount
        self.frequency = frequency
        self.date = date
    }
}

/// Single line item in the Budget "Records" list.
struct BudgetTransactionRecord: Identifiable {
    let id: UUID
    let icon: String
    let title: String
    let date: String
    let category: String
    let paymentMethod: String
    /// Positive = income, negative = expense.
    let amount: Double

    init(
        id: UUID = UUID(),
        icon: String,
        title: String,
        date: String,
        category: String,
        paymentMethod: String,
        amount: Double
    ) {
        self.id = id
        self.icon = icon
        self.title = title
        self.date = date
        self.category = category
        self.paymentMethod = paymentMethod
        self.amount = amount
    }
}

/// Savings goal used on the Goals tab list (`GoalRowView`); progress is derived from amounts.
struct Goal: Identifiable {
    let id: UUID
    let icon: String
    let name: String
    let currentAmount: Double
    let targetAmount: Double

    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return min(currentAmount / targetAmount, 1)
    }

    var progressPercentage: Int {
        Int(progress * 100)
    }

    init(id: UUID = UUID(), icon: String, name: String, currentAmount: Double, targetAmount: Double) {
        self.id = id
        self.icon = icon
        self.name = name
        self.currentAmount = currentAmount
        self.targetAmount = targetAmount
    }
}
