//
//  HistoryRowView.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI

/// History list row: icon, title, amount, and delete.
struct HistoryRowView: View {
    let transaction: HistoryTransaction
    let onDelete: () -> Void

    private var amountString: String {
        let formatted = CurrencyFormat.wholeDollarString(from: transaction.amount)
        return transaction.isIncome ? "+\(formatted)" : "-\(formatted)"
    }

    private var subtitle: String {
        "\(transaction.category) • \(transaction.date)"
    }

    var body: some View {
        HStack(alignment: .center, spacing: 11.99208) {
            iconView
            VStack(alignment: .leading, spacing: 0) {
                Text(transaction.name)
                    .font(.arimo(size: 17))
                    .foregroundColor(.primaryText)
                Text(subtitle)
                    .font(.arimo(size: 13))
                    .foregroundColor(.secondaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 25.49512)

            Text(amountString)
                .font(.arimo(size: 17, weight: .bold))
                .foregroundColor(transaction.isIncome ? .incomeGreenText : .primaryText)
                .frame(minWidth: 53, alignment: .topTrailing)

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .font(.system(size: 14))
                    .foregroundColor(.secondaryText)
                    .frame(width: 18, height: 18)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 15.98944)
        .padding(.vertical, 0)
        .frame(maxWidth: .infinity, minHeight: 69, alignment: .leading)
    }

    private var iconView: some View {
        Image(systemName: transaction.isIncome ? "arrow.down.left" : "arrow.up.right")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(transaction.isIncome ? .incomeGreen : .expenseRed)
            .frame(width: 40, height: 40)
            .background(transaction.isIncome ? Color.incomeGreenTint : Color.expenseRedTint)
            .clipShape(Circle())
    }
}

#Preview {
    VStack(spacing: 0) {
        HistoryRowView(
            transaction: HistoryTransaction(name: "Salary", category: "Salary", date: "Dec 1", amount: 5000, isIncome: true),
            onDelete: {}
        )
        Divider().background(Color.dividerLine)
        HistoryRowView(
            transaction: HistoryTransaction(name: "Rent Payment", category: "Housing", date: "Dec 2", amount: 1200, isIncome: false),
            onDelete: {}
        )
    }
    .background(Color.tabBarBackground)
}
