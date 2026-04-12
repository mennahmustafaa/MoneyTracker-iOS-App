//
//  ShoppingViewModel.swift
//  MoneyTracker
//

import Combine
import Foundation

@MainActor
final class ShoppingViewModel: ObservableObject {
    private let store: AppDataStore
    private var cancellables = Set<AnyCancellable>()

    @Published var selectedSegment: ShoppingSegment = .shoppingList
    @Published var draftItemText: String = ""

    init(store: AppDataStore) {
        self.store = store
        store.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    var items: [ShoppingItem] { store.shoppingItems }

    var filteredItems: [ShoppingItem] {
        items.filter { $0.segment == selectedSegment }
    }

    func addItem() {
        let trimmed = draftItemText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        var next = store.shoppingItems
        next.append(ShoppingItem(title: trimmed, segment: selectedSegment, isCompleted: false))
        store.setShoppingItems(next)
        draftItemText = ""
    }

    func toggleItem(_ item: ShoppingItem) {
        var next = store.shoppingItems
        guard let index = next.firstIndex(where: { $0.id == item.id }) else { return }
        next[index].isCompleted.toggle()
        store.setShoppingItems(next)
    }

    func deleteItem(_ item: ShoppingItem) {
        var next = store.shoppingItems
        next.removeAll { $0.id == item.id }
        store.setShoppingItems(next)
    }
}
