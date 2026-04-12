//
//  GoalsScreenContent.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI

/// Goals tab: content-only screen. Shared fixed toolbar lives in MainTabContainerView.
struct GoalsScreenContent: View {
    @StateObject private var viewModel: GoalsViewModel

    init(viewModel: GoalsViewModel? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel ?? GoalsViewModel())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Goals")
                .font(.arimo(size: 34, weight: .bold))
                .foregroundColor(.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(viewModel.goals) { goal in
                GoalProgressCardView(goal: goal)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }
}

#Preview {
    ScrollView {
        GoalsScreenContent()
    }
    .background(Color.appBackground)
}
