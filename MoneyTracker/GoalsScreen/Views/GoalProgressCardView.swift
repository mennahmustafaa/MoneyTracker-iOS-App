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
    var onPlusTap: () -> Void
    var onDeleteTap: () -> Void

    init(
        goal: GoalProgressItem,
        onPlusTap: @escaping () -> Void = {},
        onDeleteTap: @escaping () -> Void = {}
    ) {
        self.goal = goal
        self.onPlusTap = onPlusTap
        self.onDeleteTap = onDeleteTap
    }

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
                    .font(.inter(size: 20, weight: .bold))
                    .foregroundColor(.primaryText)
                Text(goal.deadlineText)
                    .font(.inter(size: 13))
                    .foregroundColor(.secondaryText)
            }

            Spacer(minLength: 0)

            HStack(spacing: 8) {
                GoalsDeleteButton(action: onDeleteTap)
                GoalsPlusButton(action: onPlusTap)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 59.97952, maxHeight: 59.97952, alignment: .top)
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text("Progress")
                    .font(.inter(size: 13))
                    .foregroundColor(.secondaryText)
                Spacer(minLength: 8)
                Text("\(goal.progressPercent)%")
                    .font(.inter(size: 15, weight: .bold))
                    .foregroundColor(.primaryText)
                    .lineLimit(1)
                    .layoutPriority(1)
            }
            .frame(maxWidth: .infinity, alignment: .center)

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
        HStack(alignment: .top, spacing: 4) {
            amountColumn(
                title: "Current",
                value: CurrencyFormat.dollarString(from: goal.currentAmount),
                valueColor: .primaryText,
                columnAlignment: .leading
            )
            amountColumn(
                title: "Remaining",
                value: CurrencyFormat.dollarString(from: goal.remainingAmount),
                valueColor: .donateAccentRed,
                columnAlignment: .center
            )
            amountColumn(
                title: "Target",
                value: CurrencyFormat.dollarString(from: goal.targetAmount),
                valueColor: .primaryText,
                columnAlignment: .trailing
            )
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    /// Each column is equal width; label + value share the same horizontal alignment (matches design).
    private func amountColumn(
        title: String,
        value: String,
        valueColor: Color,
        columnAlignment: HorizontalAlignment
    ) -> some View {
        VStack(alignment: columnAlignment, spacing: 4) {
            Text(title)
                .font(.inter(size: 13))
                .foregroundColor(.secondaryText)
            Text(value)
                .font(.inter(size: 17, weight: .bold))
                .foregroundColor(valueColor)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .multilineTextAlignment(textAlignment(for: columnAlignment))
        }
        .frame(maxWidth: .infinity, alignment: Alignment(horizontal: columnAlignment, vertical: .top))
    }

    private func textAlignment(for column: HorizontalAlignment) -> TextAlignment {
        switch column {
        case .leading: return .leading
        case .trailing: return .trailing
        default: return .center
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
