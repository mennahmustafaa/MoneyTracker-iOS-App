//
//  ShoppingItemRowView.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI

/// One shopping row: checkbox, title, delete.
struct ShoppingItemRowView: View {
    let item: ShoppingItem
    let onToggle: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 11.99208) {
            Button(action: onToggle) {
                ZStack {
                    Circle()
                        .stroke(
                            item.isCompleted ? Color.backgroundBlack : Color.shoppingCircleStroke,
                            lineWidth: 1.22407
                        )
                        .background(
                            Circle()
                                .fill(item.isCompleted ? Color.backgroundBlack : Color.clear)
                        )
                    if item.isCompleted {
                        Image("trueIcon")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.whiteText)
                            .scaledToFit()
                            .frame(width: 13.98119, height: 13.98119)
                    }
                }
                .frame(width: 23.98416, height: 23.98416)
            }
            .buttonStyle(.plain)

            Text(item.title)
                .font(.arimo(size: 17))
                .strikethrough(item.isCompleted, color: .shoppingPlaceholderText)
                .foregroundColor(item.isCompleted ? .shoppingPlaceholderText : .primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: onDelete) {
                Image("deleteIcon")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.shoppingPlaceholderText)
                    .scaledToFit()
                    .frame(width: 17.99768, height: 17.99768)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 15.98944)
        .padding(.vertical, 0)
        .frame(maxWidth: .infinity, minHeight: 51.9848, maxHeight: 51.9848, alignment: .leading)
    }
}

#Preview {
    VStack(spacing: 0) {
        ShoppingItemRowView(
            item: ShoppingItem(title: "Milk", segment: .shoppingList, isCompleted: false),
            onToggle: {},
            onDelete: {}
        )
        Divider().background(Color.dividerLine)
        ShoppingItemRowView(
            item: ShoppingItem(title: "Eggs", segment: .shoppingList, isCompleted: true),
            onToggle: {},
            onDelete: {}
        )
    }
    .background(Color.tabBarBackground)
}
