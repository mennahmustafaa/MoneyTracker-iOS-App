//
//  GoalProgressCardView.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI

/// Large card for one goal: icon, progress bar, current / remaining / target.
struct GoalProgressCardView: View {
    let goal: GoalProgressItem

    var body: some View {
        VStack(alignment: .leading, spacing: 15.98942) {
            topSection
            progressSection
            amountsSection
        }
        .padding(.horizontal, 19.9868)
        .padding(.top, 19.98682)
        .padding(.bottom, 0)
        .frame(maxWidth: .infinity, minHeight: 215.4175, maxHeight: 215.4175, alignment: .topLeading)
        .background(Color.tabBarBackground)
        .cornerRadius(16)
        .shadow(color: Color.shadowBlack10, radius: 1, x: 0, y: 1)
        .shadow(color: Color.shadowBlack10, radius: 1.5, x: 0, y: 1)
    }

    private var topSection: some View {
        HStack(alignment: .top) {
            Text(goal.icon)
                .font(.arimo(size: 40))
                .foregroundColor(.primaryText)

            VStack(alignment: .leading, spacing: 2) {
                Text(goal.title)
                    .font(.arimo(size: 20, weight: .bold))
                    .foregroundColor(.primaryText)
                Text(goal.deadlineText)
                    .font(.arimo(size: 13))
                    .foregroundColor(.secondaryText)
            }

            Spacer(minLength: 0)

            ZStack {
                Circle()
                    .fill(Color.backgroundBlack)
                    .frame(width: 35.99536, height: 35.99536)
                    .shadow(color: Color.shadowBlack10, radius: 2, x: 0, y: 2)
                    .shadow(color: Color.shadowBlack10, radius: 3, x: 0, y: 4)
                Image(systemName: "plus")
                    .font(.system(size: 17.99768, weight: .bold))
                    .foregroundColor(.whiteText)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 59.97952, maxHeight: 59.97952, alignment: .top)
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Progress")
                    .font(.arimo(size: 13))
                    .foregroundColor(.secondaryText)
                Spacer(minLength: 0)
                Text("\(goal.progressPercent)%")
                    .font(.arimo(size: 15, weight: .bold))
                    .foregroundColor(.primaryText)
                    .frame(width: 31, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity, minHeight: 22.49232, maxHeight: 22.49232, alignment: .center)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.donateTrackBackground)
                    Capsule()
                        .fill(Color.backgroundBlack)
                        .frame(width: geo.size.width * goal.progress)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 7.99472, maxHeight: 7.99472, alignment: .topLeading)
        }
    }

    private var amountsSection: some View {
        HStack {
            amountColumn(
                title: "Current",
                value: CurrencyFormat.dollarString(from: goal.currentAmount),
                valueColor: .primaryText,
                valueAlignment: .topLeading
            )
            Spacer(minLength: 0)
            amountColumn(
                title: "Remaining",
                value: CurrencyFormat.dollarString(from: goal.remainingAmount),
                valueColor: .donateAccentRed,
                valueAlignment: .top
            )
            Spacer(minLength: 0)
            amountColumn(
                title: "Target",
                value: CurrencyFormat.dollarString(from: goal.targetAmount),
                valueColor: .primaryText,
                valueAlignment: .topTrailing
            )
        }
        .frame(maxWidth: .infinity, minHeight: 45.00376, maxHeight: 45.00376, alignment: .center)
    }

    private func amountColumn(
        title: String,
        value: String,
        valueColor: Color,
        valueAlignment: Alignment
    ) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.arimo(size: 13))
                .multilineTextAlignment(.center)
                .foregroundColor(.secondaryText)
            Text(value)
                .font(.arimo(size: 17, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(valueColor)
                .frame(width: 71, alignment: valueAlignment)
        }
    }
}

#Preview {
    GoalProgressCardView(
        goal: GoalProgressItem(
            icon: "✈️",
            title: "Trip to Japan",
            deadlineText: "Deadline passed",
            currentAmount: 1200,
            targetAmount: 3000
        )
    )
    .padding()
    .background(Color.appBackground)
}
