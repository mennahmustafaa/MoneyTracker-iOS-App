//
//  GoalsPlusButton.swift
//  MoneyTracker
//

import SwiftUI

/// Black circular **+** with shadows (Goals header and goal cards).
struct GoalsPlusButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 0) {
                Image("plusIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 19.99219, height: 19.99219)
            }
            .padding(.leading, 7.99219)
            .padding(.trailing, 8.01563)
            .frame(width: 36, height: 36, alignment: .center)
            .background(Color.backgroundBlack)
            .clipShape(Circle())
            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 4)
            .shadow(color: Color.black.opacity(0.1), radius: 7.5, x: 0, y: 10)
            .contentShape(Circle())
        }
        .buttonStyle(.plain)
    }
}
