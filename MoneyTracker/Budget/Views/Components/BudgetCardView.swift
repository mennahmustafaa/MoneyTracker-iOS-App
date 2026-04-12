//
//  BudgetCardView.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI

/// Dark summary card: current balance plus income and expense sub-cards.
struct BudgetCardView: View {
    let budgetSummary: BudgetSummary

    private var formattedBalance: String {
        CurrencyFormat.dollarString(from: budgetSummary.currentBalance)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 7.99473) {
            Text("CURRENT BALANCE")
                .font(.arimo(size: 13))
                .foregroundColor(.whiteOpacity60)

            Text(formattedBalance)
                .font(.arimo(size: 40, weight: .bold))
                .foregroundColor(.whiteText)

            HStack(alignment: .center, spacing: 16) {
                IncomeExpenseSubCardView(
                    title: "Income",
                    amount: budgetSummary.income,
                    isIncome: true
                )
                IncomeExpenseSubCardView(
                    title: "Expenses",
                    amount: budgetSummary.expenses,
                    isIncome: false
                )
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.leading, 23.98416)
        .padding(.trailing, 23.98417)
        .padding(.top, 23.98415)
        .padding(.bottom, 0)
        .frame(maxWidth: .infinity, minHeight: 248.92647, maxHeight: 248.92647, alignment: .topLeading)
        .background(Color.backgroundBlack)
        .cornerRadius(20)
        .shadow(color: Color.shadowBlack10, radius: 3, x: 0, y: 4)
        .shadow(color: Color.shadowBlack10, radius: 7.5, x: 0, y: 10)
    }
}

#Preview {
    BudgetCardView(budgetSummary: .default)
        .padding()
}
