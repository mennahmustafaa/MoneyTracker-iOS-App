//
//  HistoryViewModel.swift
//  MoneyTracker
//

import Combine
import Foundation

enum HistoryFilter: String, CaseIterable {
    case all = "All"
    case recurring = "Recurring"
}

@MainActor
/// History list + filter; data is the same `StoredTransaction` list as Budget.
final class HistoryViewModel: ObservableObject {
    private let store: AppDataStore
    private var cancellables = Set<AnyCancellable>()

    @Published var selectedFilter: HistoryFilter = .all

    init(store: AppDataStore) {
        self.store = store
        store.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    var transactions: [HistoryTransaction] {
        store.historyRows(filter: selectedFilter)
    }

    func deleteTransaction(id: UUID) {
        store.deleteTransaction(id: id)
    }
}
