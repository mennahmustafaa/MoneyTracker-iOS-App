//
//  HistoryViewModel.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import Combine
import Foundation

/// Segment filter for the History list (filtering not yet applied to sample data).
enum HistoryFilter: String, CaseIterable {
    case all = "All"
    case recurring = "Recurring"
}

@MainActor
/// History tab state: transactions + selected filter.
final class HistoryViewModel: ObservableObject {
    @Published var transactions: [HistoryTransaction]
    @Published var selectedFilter: HistoryFilter

    init(
        transactions: [HistoryTransaction]? = nil,
        selectedFilter: HistoryFilter = .all
    ) {
        self.transactions = transactions ?? Self.defaultTransactions
        self.selectedFilter = selectedFilter
    }

    func deleteTransaction(id: UUID) {
        transactions.removeAll { $0.id == id }
    }

    // MARK: - Sample data

    private static let defaultTransactions: [HistoryTransaction] = [
        HistoryTransaction(name: "Salary", category: "Salary", date: "Dec 1", amount: 5000, isIncome: true),
        HistoryTransaction(name: "Rent Payment", category: "Housing", date: "Dec 2", amount: 1200, isIncome: false),
        HistoryTransaction(name: "Groceries", category: "Food", date: "Dec 5", amount: 150, isIncome: false),
        HistoryTransaction(name: "Gas", category: "Transport", date: "Dec 6", amount: 50, isIncome: false),
        HistoryTransaction(name: "Restaurant", category: "Food", date: "Dec 8", amount: 80, isIncome: false),
        HistoryTransaction(name: "Uber", category: "Transport", date: "Dec 10", amount: 40, isIncome: false),
        HistoryTransaction(name: "Shopping", category: "Fun", date: "Dec 12", amount: 200, isIncome: false),
        HistoryTransaction(name: "Freelance Work", category: "Freelance", date: "Dec 15", amount: 500, isIncome: true),
        HistoryTransaction(name: "Groceries", category: "Food", date: "Dec 18", amount: 120, isIncome: false),
        HistoryTransaction(name: "Movie Night", category: "Fun", date: "Dec 20", amount: 60, isIncome: false)
    ]
}
