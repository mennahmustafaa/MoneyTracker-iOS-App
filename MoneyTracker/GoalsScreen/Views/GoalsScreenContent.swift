//
//  GoalsScreenContent.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI

/// Goals tab: content-only screen. Shared fixed toolbar lives in MainTabContainerView.
@MainActor
struct GoalsScreenContent: View {
    @ObservedObject var viewModel: GoalsViewModel
    var onAddGoalTap: () -> Void
    var onGoalCardPlusTap: (GoalProgressItem) -> Void
    var onGoalDeleted: (UUID) -> Void

    @State private var goalPendingDelete: GoalProgressItem?

    init(
        viewModel: GoalsViewModel,
        onAddGoalTap: @escaping () -> Void = {},
        onGoalCardPlusTap: @escaping (GoalProgressItem) -> Void = { _ in },
        onGoalDeleted: @escaping (UUID) -> Void = { _ in }
    ) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        self.onAddGoalTap = onAddGoalTap
        self.onGoalCardPlusTap = onGoalCardPlusTap
        self.onGoalDeleted = onGoalDeleted
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerSection

            ForEach(viewModel.goals) { goal in
                GoalProgressCardView(
                    goal: goal,
                    onPlusTap: { onGoalCardPlusTap(goal) },
                    onDeleteTap: { goalPendingDelete = goal }
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 16)
        .alert(
            "Delete this goal?",
            isPresented: Binding(
                get: { goalPendingDelete != nil },
                set: { if !$0 { goalPendingDelete = nil } }
            )
        ) {
            Button("Cancel", role: .cancel) {
                goalPendingDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let g = goalPendingDelete {
                    viewModel.deleteGoal(id: g.id)
                    onGoalDeleted(g.id)
                }
                goalPendingDelete = nil
            }
        } message: {
            if let g = goalPendingDelete {
                Text("\"\(g.title)\" will be removed. This cannot be undone.")
            }
        }
    }

    private var headerSection: some View {
        HStack(alignment: .center) {
            Text("Goals")
                .font(.inter(size: 34, weight: .bold))
                .foregroundColor(.black)
            Spacer(minLength: 8)
            GoalsPlusButton(action: onAddGoalTap)
        }
        .frame(maxWidth: .infinity, minHeight: 70.47656, maxHeight: 70.47656, alignment: .center)
    }
}

#Preview {
    ScrollView {
        GoalsScreenContent(viewModel: GoalsViewModel(store: AppDataStore.preview))
    }
    .background(Color.appBackground)
}
