//
//  ShoppingViewModel.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import Combine
import Foundation

@MainActor
/// Shopping list + wishlist items for the Shopping tab.
final class ShoppingViewModel: ObservableObject {
    @Published var selectedSegment: ShoppingSegment
    @Published var draftItemText: String
    @Published var items: [ShoppingItem]

    init(
        selectedSegment: ShoppingSegment = .shoppingList,
        draftItemText: String = "",
        items: [ShoppingItem]? = nil
    ) {
        self.selectedSegment = selectedSegment
        self.draftItemText = draftItemText
        self.items = items ?? Self.defaultItems
    }

    var filteredItems: [ShoppingItem] {
        items.filter { $0.segment == selectedSegment }
    }

    func addItem() {
        let trimmed = draftItemText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        items.append(
            ShoppingItem(
                title: trimmed,
                segment: selectedSegment,
                isCompleted: false
            )
        )
        draftItemText = ""
    }

    func toggleItem(_ item: ShoppingItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].isCompleted.toggle()
    }

    func deleteItem(_ item: ShoppingItem) {
        items.removeAll { $0.id == item.id }
    }

    // MARK: - Sample data

    private static let defaultItems: [ShoppingItem] = [
        ShoppingItem(title: "Milk", segment: .shoppingList, isCompleted: false),
        ShoppingItem(title: "Bread", segment: .shoppingList, isCompleted: false),
        ShoppingItem(title: "Eggs", segment: .shoppingList, isCompleted: true),
        ShoppingItem(title: "Coffee", segment: .shoppingList, isCompleted: false),
        ShoppingItem(title: "Apples", segment: .shoppingList, isCompleted: false),
        ShoppingItem(title: "New Blender", segment: .wishlist, isCompleted: false),
        ShoppingItem(title: "Office Chair", segment: .wishlist, isCompleted: false)
    ]
}
