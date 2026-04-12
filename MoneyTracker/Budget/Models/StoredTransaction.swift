//
//  StoredTransaction.swift
//  MoneyTracker
//
//  Single source of truth for money movements (Budget + History). Persisted locally;
//  swap `AppDataStore` persistence for Supabase sync when auth is ready.
//

import Foundation

struct StoredTransaction: Codable, Identifiable, Equatable {
    var id: UUID
    /// User-selected transaction date.
    var occurredAt: Date
    var title: String
    var category: String
    var paymentMethod: String
    var icon: String
    var notes: String?
    /// Positive = income, negative = expense.
    var amount: Double
    var isRecurring: Bool
}
