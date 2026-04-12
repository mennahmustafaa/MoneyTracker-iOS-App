//
//  BudgetRecordRowView.swift
//  MoneyTracker
//

import SwiftUI

/// One line in the Budget home “Records” list.
struct BudgetRecordRowView: View {
    let record: BudgetTransactionRecord

    private var metadataLine: String {
        "\(record.date) • \(record.category) • \(record.paymentMethod)"
    }

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Text(record.icon)
                .font(.inter(size: 22))
                .frame(width: 44, height: 44)
                .background(Color(hex: "E8E8ED"))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(record.title)
                    .font(.inter(size: 17, weight: .semibold))
                    .foregroundColor(.primaryText)
                Text(metadataLine)
                    .font(.inter(size: 13))
                    .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.58))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text(CurrencyFormat.signedWholeDollarString(from: record.amount))
                .font(.inter(size: 17, weight: .bold))
                .multilineTextAlignment(.trailing)
                .foregroundColor(.primaryText)
        }
    }
}

#Preview {
    BudgetRecordRowView(
        record: BudgetTransactionRecord(
            icon: "🛒",
            title: "Groceries",
            date: "Tue, Apr 7",
            category: "Food",
            paymentMethod: "Card",
            amount: -140
        )
    )
    .padding()
}
