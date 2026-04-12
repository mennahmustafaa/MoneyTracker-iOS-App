//
//  DonateViewModel.swift
//  MoneyTracker
//

import Combine
import Foundation

@MainActor
final class DonateViewModel: ObservableObject {
    private let store: AppDataStore
    private var cancellables = Set<AnyCancellable>()

    init(store: AppDataStore) {
        self.store = store
        store.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    var quote: String { store.quote }
    var quoteAuthor: String { store.quoteAuthor }
    var causes: [ImpactCause] { store.causes }
    var donations: [DonationRecord] { store.donations }

    var totalDonations: Double {
        donations.reduce(0) { $0 + $1.amount }
    }

    var totalDonationsCount: Int { donations.count }

    var monthlyAverage: Double {
        guard !donations.isEmpty else { return 0 }
        return totalDonations / Double(donations.count)
    }

    func addDonation(
        amount: Double,
        organization: String,
        category: String,
        isRecurring: Bool,
        date: Date,
        iconEmoji: String?
    ) {
        store.addDonation(
            amount: amount,
            organization: organization,
            category: category,
            isRecurring: isRecurring,
            date: date,
            iconEmoji: iconEmoji
        )
    }

    func updateDonation(
        id: UUID,
        amount: Double,
        organization: String,
        category: String,
        isRecurring: Bool,
        date: Date,
        iconEmoji: String?
    ) {
        store.updateDonation(
            id: id,
            amount: amount,
            organization: organization,
            category: category,
            isRecurring: isRecurring,
            date: date,
            iconEmoji: iconEmoji
        )
    }
}
