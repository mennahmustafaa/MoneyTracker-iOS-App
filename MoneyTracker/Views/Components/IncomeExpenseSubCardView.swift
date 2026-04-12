//
//  IncomeExpenseSubCardView.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI

/// Income or expense tile inside the main budget card (semi-transparent on black).
struct IncomeExpenseSubCardView: View {
    let title: String
    let amount: Double
    let isIncome: Bool

    private var formattedAmount: String {
        CurrencyFormat.dollarString(from: amount)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 7.99474) {
            HStack(alignment: .center, spacing: 7.99472) {
                Image(systemName: isIncome ? "chart.line.uptrend.xyaxis" : "chart.line.downtrend.xyaxis")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isIncome ? Color.incomeGreen : Color.expenseRed)
                    .frame(width: 15.98944, height: 15.98944)
                Text(title)
                    .font(.arimo(size: 13))
                    .foregroundColor(.whiteOpacity80)
            }
            .padding(0)
            .frame(maxWidth: .infinity, minHeight: 19.50864, maxHeight: 19.50864, alignment: .leading)

            Text(formattedAmount)
                .font(.arimo(size: 20, weight: .bold))
                .foregroundColor(.whiteText)
                .frame(width: 51, alignment: .topLeading)
        }
        .padding(.horizontal, 15.98944)
        .padding(.top, 15.98944)
        .padding(.bottom, 0)
        .frame(maxWidth: .infinity, minHeight: 89.49112, maxHeight: 89.49112, alignment: .topLeading)
        .background(Color.cardOverlayWhite)
        .cornerRadius(16)
    }
}

#Preview {
    ZStack {
        Color.backgroundBlack
            .ignoresSafeArea()
        VStack(spacing: 8) {
            IncomeExpenseSubCardView(title: "Income", amount: 0, isIncome: true)
            IncomeExpenseSubCardView(title: "Expenses", amount: 0, isIncome: false)
        }
        .padding()
    }
}
