//
//  GoalRowView.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI

// MARK: - Goal icon

/// Emoji or text in the goal row; system font avoids clipping.
private struct GoalIconView: View {
    let icon: String

    var body: some View {
        Text(icon)
            .font(.system(size: 28))
            .foregroundColor(.primaryText)
            .frame(width: 32, height: 32)
    }
}

/// Single goal with progress bar (used in shared sections; model is `Goal`).
struct GoalRowView: View {
    let goal: Goal

    private var progressText: String {
        "\(CurrencyFormat.wholeDollarString(from: goal.currentAmount)) of \(CurrencyFormat.wholeDollarString(from: goal.targetAmount))"
    }

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            GoalIconView(icon: goal.icon)

            VStack(alignment: .leading, spacing: 6) {
                Text(goal.name)
                    .font(.arimo(size: 17))
                    .foregroundColor(.primaryText)

                Text(progressText)
                    .font(.arimo(size: 13))
                    .foregroundColor(.secondaryText)
                    .frame(alignment: .topLeading)
                    .fixedSize(horizontal: true, vertical: false)

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.progressBarUnfilled)
                            .frame(height: 6)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.progressBarFilled)
                            .frame(width: geometry.size.width * goal.progress, height: 6)
                    }
                }
                .frame(height: 6)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text("\(goal.progressPercentage)%")
                .font(.arimo(size: 17))
                .foregroundColor(.secondaryText)
        }
        .padding(.leading, 17.55778)
        .padding(.trailing, 17.5578)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, minHeight: 90.96383, maxHeight: 90.96383, alignment: .center)
    }
}

#Preview {
    VStack(spacing: 0) {
        GoalRowView(goal: Goal(icon: "✈️", name: "Trip to Japan", currentAmount: 1200, targetAmount: 3000))
        Divider().background(Color.dividerLine)
        GoalRowView(goal: Goal(icon: "💻", name: "New Laptop", currentAmount: 500, targetAmount: 1500))
    }
    .padding()
}
