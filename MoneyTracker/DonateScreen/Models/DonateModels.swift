//
//  DonateModels.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import Foundation

/// Row in “Impact by Cause” with amount and progress toward a target (0…1).
struct ImpactCause: Identifiable, Codable {
    let id: UUID
    let name: String
    let amount: Double
    /// 0...1
    let progress: Double

    init(id: UUID = UUID(), name: String, amount: Double, progress: Double) {
        self.id = id
        self.name = name
        self.amount = amount
        self.progress = progress
    }
}

/// Past donation line for the Donate history list.
struct DonationRecord: Identifiable, Codable {
    let id: UUID
    let organization: String
    let cause: String
    let date: String
    let frequency: String
    let amount: Double
    /// Optional emoji chosen in the sheet; older saved data omits this key.
    let iconEmoji: String?

    init(
        id: UUID = UUID(),
        organization: String,
        cause: String,
        date: String,
        frequency: String,
        amount: Double,
        iconEmoji: String? = nil
    ) {
        self.id = id
        self.organization = organization
        self.cause = cause
        self.date = date
        self.frequency = frequency
        self.amount = amount
        self.iconEmoji = iconEmoji
    }
}
