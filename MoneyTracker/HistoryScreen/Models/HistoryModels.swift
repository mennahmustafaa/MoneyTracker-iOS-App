//
//  HistoryModels.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import Foundation

/// One row in History; `amount` is the absolute value; sign comes from `isIncome`.
struct HistoryTransaction: Identifiable {
    let id: UUID
    let name: String
    let category: String
    let date: String
    let amount: Double
    let isIncome: Bool

    init(
        id: UUID = UUID(),
        name: String,
        category: String,
        date: String,
        amount: Double,
        isIncome: Bool
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.date = date
        self.amount = amount
        self.isIncome = isIncome
    }
}
