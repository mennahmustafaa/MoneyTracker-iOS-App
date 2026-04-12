//
//  BudgetViewModel.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import Combine
import Foundation

@MainActor
/// State for the Budget (Home) screen: summary card and recent records.
final class BudgetViewModel: ObservableObject {
    @Published var budgetSummary: BudgetSummary
    /// Shown in the Records list (preview of recent activity).
    @Published var records: [BudgetTransactionRecord]
    /// Total count for "View all N transactions" (may exceed `records.count`).
    @Published var totalTransactionCount: Int

    init(
        budgetSummary: BudgetSummary? = nil,
        records: [BudgetTransactionRecord]? = nil,
        totalTransactionCount: Int? = nil
    ) {
        self.budgetSummary = budgetSummary ?? .default
        self.records = records ?? .defaultRecords
        self.totalTransactionCount = totalTransactionCount ?? 13
    }

    private static let recordDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = "EEE, MMM d"
        return f
    }()

    /// Inserts a new record at the top and updates balance / income / expense totals.
    func addTransaction(
        amount: Double,
        isIncome: Bool,
        title: String,
        icon: String,
        category: String,
        paymentMethod: String,
        date: Date
    ) {
        let signed = isIncome ? amount : -amount
        let dateStr = Self.recordDateFormatter.string(from: date)
        let record = BudgetTransactionRecord(
            icon: icon,
            title: title,
            date: dateStr,
            category: category,
            paymentMethod: paymentMethod,
            amount: signed
        )
        records.insert(record, at: 0)
        totalTransactionCount += 1
        budgetSummary = BudgetSummary(
            currentBalance: budgetSummary.currentBalance + signed,
            income: isIncome ? budgetSummary.income + amount : budgetSummary.income,
            expenses: isIncome ? budgetSummary.expenses : budgetSummary.expenses + amount
        )
    }
}

// MARK: - Sample data

extension BudgetSummary {
    static let `default` = BudgetSummary(
        currentBalance: -1675,
        income: 600,
        expenses: 2275
    )
}

extension Array where Element == BudgetTransactionRecord {
    static let defaultRecords: [BudgetTransactionRecord] = [
        BudgetTransactionRecord(icon: "🛒", title: "Groceries", date: "Tue, Apr 7", category: "Food", paymentMethod: "Card", amount: -140),
        BudgetTransactionRecord(icon: "🎬", title: "Movie & Dinner", date: "Tue, Apr 7", category: "Fun", paymentMethod: "Card", amount: -75),
        BudgetTransactionRecord(icon: "☕", title: "Coffee Shop", date: "Tue, Apr 7", category: "Food", paymentMethod: "Cash", amount: -45),
        BudgetTransactionRecord(icon: "🛍️", title: "Shopping", date: "Mon, Apr 6", category: "Fun", paymentMethod: "Card", amount: -250),
        BudgetTransactionRecord(icon: "🚗", title: "Uber", date: "Sun, Apr 5", category: "Transport", paymentMethod: "Wallet", amount: -45),
        BudgetTransactionRecord(icon: "💼", title: "Freelance Work", date: "Sun, Apr 5", category: "Freelance", paymentMethod: "Wallet", amount: 600),
        BudgetTransactionRecord(icon: "🍽️", title: "Restaurant", date: "Sat, Apr 4", category: "Food", paymentMethod: "Card", amount: -95),
        BudgetTransactionRecord(icon: "⚡", title: "Electric Bill", date: "Sat, Apr 4", category: "Housing", paymentMethod: "Card", amount: -85),
        BudgetTransactionRecord(icon: "⛽", title: "Gas", date: "Fri, Apr 3", category: "Transport", paymentMethod: "Card", amount: -65),
        BudgetTransactionRecord(icon: "🅿️", title: "Parking", date: "Fri, Apr 3", category: "Transport", paymentMethod: "Cash", amount: -40)
    ]
}
