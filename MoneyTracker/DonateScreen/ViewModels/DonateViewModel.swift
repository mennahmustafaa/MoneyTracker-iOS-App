//
//  DonateViewModel.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import Combine
import Foundation

@MainActor
/// Donate tab: quote, impact by cause, donation history; `addDonation` prepends a row.
final class DonateViewModel: ObservableObject {
    @Published var quote: String
    @Published var quoteAuthor: String
    @Published var causes: [ImpactCause]
    @Published var donations: [DonationRecord]

    init(
        quote: String = "\"No one has ever become poor by giving.\"",
        quoteAuthor: String = "— Anne Frank",
        causes: [ImpactCause]? = nil,
        donations: [DonationRecord]? = nil
    ) {
        self.quote = quote
        self.quoteAuthor = quoteAuthor
        self.causes = causes ?? Self.defaultCauses
        self.donations = donations ?? Self.defaultDonations
    }

    var totalDonations: Double {
        donations.reduce(0) { $0 + $1.amount }
    }

    var totalDonationsCount: Int {
        donations.count
    }

    var monthlyAverage: Double {
        guard !donations.isEmpty else { return 0 }
        return totalDonations / Double(donations.count)
    }

    // MARK: - Sample data

    private static let defaultCauses: [ImpactCause] = [
        ImpactCause(name: "Healthcare", amount: 100, progress: 0.38),
        ImpactCause(name: "Education", amount: 75, progress: 0.27),
        ImpactCause(name: "Hunger Relief", amount: 50, progress: 0.2),
        ImpactCause(name: "Animal Welfare", amount: 25, progress: 0.12)
    ]

    private static let defaultDonations: [DonationRecord] = [
        DonationRecord(organization: "Red Cross", cause: "Healthcare", date: "Dec 1", frequency: "yearly", amount: 100),
        DonationRecord(organization: "Local Food Bank", cause: "Hunger Relief", date: "Dec 15", frequency: "monthly", amount: 50),
        DonationRecord(organization: "Animal Shelter", cause: "Animal Welfare", date: "Dec 20", frequency: "yearly", amount: 25),
        DonationRecord(organization: "Education Fund", cause: "Education", date: "Nov 20", frequency: "yearly", amount: 75)
    ]

    private static let donationDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = "MMM d"
        return f
    }()

    /// Inserts a new donation at the top of the list.
    func addDonation(
        amount: Double,
        organization: String,
        category: String,
        isRecurring: Bool,
        date: Date
    ) {
        let dateStr = Self.donationDateFormatter.string(from: date)
        let frequency = isRecurring ? "monthly" : "one-time"
        let org = organization.trimmingCharacters(in: .whitespaces)
        let cause = category.trimmingCharacters(in: .whitespaces)
        let record = DonationRecord(
            organization: org.isEmpty ? "Donation" : org,
            cause: cause.isEmpty ? "General" : cause,
            date: dateStr,
            frequency: frequency,
            amount: amount
        )
        donations.insert(record, at: 0)
    }
}
