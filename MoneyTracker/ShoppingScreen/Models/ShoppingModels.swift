//
//  ShoppingModels.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import Foundation

/// Which tab is active in Shopping: list vs wishlist.
enum ShoppingSegment: String, Codable, CaseIterable {
    case shoppingList = "Shopping List"
    case wishlist = "Wishlist"
}

/// Single shopping or wishlist line with completion state.
struct ShoppingItem: Identifiable, Codable {
    let id: UUID
    let title: String
    let segment: ShoppingSegment
    var isCompleted: Bool

    init(id: UUID = UUID(), title: String, segment: ShoppingSegment, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.segment = segment
        self.isCompleted = isCompleted
    }
}
