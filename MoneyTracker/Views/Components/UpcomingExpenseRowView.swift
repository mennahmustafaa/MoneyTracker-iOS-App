//
//  UpcomingExpenseRowView.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI

/// One upcoming bill row (name, frequency, date, amount).
struct UpcomingExpenseRowView: View {
    let expense: UpcomingExpense

    private var formattedAmount: String {
        "-" + CurrencyFormat.wholeDollarString(from: expense.amount)
    }

    private var subtitle: String {
        "\(expense.frequency) • \(expense.date)"
    }

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text(expense.name)
                    .font(.arimo(size: 17, weight: .bold))
                    .foregroundColor(.primaryText)
                Text(subtitle)
                    .font(.arimo(size: 13))
                    .foregroundColor(.secondaryText)
                    .frame(width: 90, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity, minHeight: 19.50864, maxHeight: 19.50864, alignment: .leading)
            Spacer(minLength: 0)
            Text(formattedAmount)
                .font(.arimo(size: 17, weight: .bold))
                .foregroundColor(.primaryText)
                .frame(minWidth: 53, alignment: .topTrailing)
        }
        .padding(.horizontal, 15.98944)
        .padding(.vertical, 0)
        .frame(maxWidth: .infinity, minHeight: 71, maxHeight: 71, alignment: .center)
    }
}

#Preview {
    VStack(spacing: 0) {
        UpcomingExpenseRowView(expense: UpcomingExpense(name: "Rent", amount: 1200, frequency: "Monthly", date: "Jan 1"))
        Divider().background(Color.dividerLine)
        UpcomingExpenseRowView(expense: UpcomingExpense(name: "Netflix", amount: 15, frequency: "Monthly", date: "Jan 1"))
    }
    .padding()
}
