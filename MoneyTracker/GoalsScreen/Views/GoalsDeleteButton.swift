//
//  GoalsDeleteButton.swift
//  MoneyTracker
//

import SwiftUI

/// Soft circular delete control (pairs with `GoalsPlusButton` on goal cards).
struct GoalsDeleteButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image("deleteIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)
                .frame(width: 36, height: 36)
                .background(Color.segmentTrackBackground)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.dividerLine, lineWidth: 1)
                )
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Delete goal")
    }
}
