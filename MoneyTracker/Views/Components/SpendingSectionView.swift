//
//  SpendingSectionView.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI

/// Monthly spending area; shows empty state until expense data is wired in.
struct SpendingSectionView: View {
    let hasExpensesThisMonth: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Spending")
                .font(.arimo(size: 22, weight: .bold))
                .foregroundColor(.primaryText)

            if hasExpensesThisMonth {
                // TODO: Replace with expense list when available
                EmptyView()
            } else {
                emptyStateCard
            }
        }
    }

    private var emptyStateCard: some View {
        Text("No expenses this month")
            .font(.arimo(size: 15))
            .multilineTextAlignment(.center)
            .foregroundColor(.secondaryText)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.leading, 23.98416)
            .padding(.trailing, 23.98417)
            .padding(.top, 23.98413)
            .padding(.bottom, 0)
            .frame(maxWidth: .infinity, minHeight: 70.46063, maxHeight: 70.46063, alignment: .center)
            .background(Color.tabBarBackground)
            .cornerRadius(12)
            .shadow(color: Color.shadowBlack10, radius: 1, x: 0, y: 1)
            .shadow(color: Color.shadowBlack10, radius: 1.5, x: 0, y: 1)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        SpendingSectionView(hasExpensesThisMonth: false)
    }
    .padding()
    .background(Color.appBackground)
}
