//
//  BudgetViewModel.swift
//  MoneyTracker
//

import Combine
import Foundation

@MainActor
/// Home tab: reads/writes transactions through `AppDataStore` (persisted locally).
final class BudgetViewModel: ObservableObject {
    private let store: AppDataStore
    private var cancellables = Set<AnyCancellable>()

    init(store: AppDataStore) {
        self.store = store
        store.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    var budgetSummary: BudgetSummary { store.budgetSummary }

    /// Recent rows for the Budget “Records” list.
    var records: [BudgetTransactionRecord] { store.budgetRecordRows(limit: 14) }

    var totalTransactionCount: Int { store.transactions.count }

    func addTransaction(
        amount: Double,
        isIncome: Bool,
        title: String,
        icon: String,
        category: String,
        paymentMethod: String,
        date: Date,
        notes: String?,
        isRecurring: Bool = false
    ) {
        store.addTransaction(
            amount: amount,
            isIncome: isIncome,
            title: title,
            icon: icon,
            category: category,
            paymentMethod: paymentMethod,
            date: date,
            notes: notes,
            isRecurring: isRecurring
        )
    }
}
