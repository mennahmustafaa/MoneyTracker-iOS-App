//
//  MainTabContainerView.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI

/// Single root: tab bar + scroll content. Uses `AppSessionContainer` for persisted app data (local JSON today, Supabase later).
@MainActor
struct MainTabContainerView: View {
    @State private var selectedTab: TabItem = .home
    @State private var showingProfileFromBudget = false
    @State private var showNewGoalSheet = false
    @State private var showDonateNewDonationSheet = false
    @State private var addToGoalTarget: GoalProgressItem?

    @StateObject private var session: AppSessionContainer

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(session: SessionViewModel, onLogout: @escaping () -> Void) {
        _session = StateObject(wrappedValue: AppSessionContainer(session: session, onLogout: onLogout))
    }

    /// Stable identity for tab + profile overlay so only these swaps animate (not scroll).
    private var mainScrollIdentity: String {
        if showingProfileFromBudget, selectedTab == .home {
            return "profile"
        }
        return "tab-\(selectedTab.rawValue)"
    }

    private var tabContentAnimation: Animation {
        reduceMotion ? .easeOut(duration: 0.001) : AppMotion.contentFade
    }

    var body: some View {
        ScrollView {
            Group {
                if showingProfileFromBudget, selectedTab == .home {
                    profileFromBudgetStack
                } else {
                    screenContent(for: selectedTab)
                }
            }
            .id(mainScrollIdentity)
            .transition(.appTabContent)
            .padding(.bottom, 8)
        }
        .animation(tabContentAnimation, value: mainScrollIdentity)
        .background(Color.appBackground)
        .sheet(isPresented: $showNewGoalSheet) {
            NewGoalSheet(viewModel: session.goals)
                .presentationDragIndicator(.hidden)
        }
        .sheet(isPresented: $showDonateNewDonationSheet) {
            NewDonationSheet(viewModel: session.donate)
                .presentationDragIndicator(.hidden)
        }
        .sheet(item: $addToGoalTarget) { goal in
            AddToGoalSheet(goal: goal, viewModel: session.goals)
                .presentationDetents([.height(320), .medium])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(20)
                .presentationBackground(.white)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            TabBarView(selectedTab: selectedTab) { tab in
                selectedTab = tab
                showingProfileFromBudget = false
                showNewGoalSheet = false
                showDonateNewDonationSheet = false
                addToGoalTarget = nil
            }
            .frame(height: TabBarView.height)
        }
    }

    @ViewBuilder
    private func screenContent(for tab: TabItem) -> some View {
        switch tab {
        case .home:
            BudgetScreenContent(
                viewModel: session.budget,
                onOpenProfile: { showingProfileFromBudget = true },
                onViewAllTransactions: { selectedTab = .history }
            )
        case .history:
            HistoryScreenContent(viewModel: session.history)
        case .shopping:
            ShoppingScreenContent(viewModel: session.shopping)
        case .goals:
            GoalsScreenContent(
                viewModel: session.goals,
                onAddGoalTap: { showNewGoalSheet = true },
                onGoalCardPlusTap: { addToGoalTarget = $0 },
                onGoalDeleted: { id in
                    if addToGoalTarget?.id == id { addToGoalTarget = nil }
                }
            )
        case .donate:
            DonateScreenContent(viewModel: session.donate) {
                showDonateNewDonationSheet = true
            }
        }
    }

    private var profileFromBudgetStack: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                showingProfileFromBudget = false
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Budget")
                        .font(.arimo(size: 17, weight: .semibold))
                }
                .foregroundColor(.primaryText)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 20)
            .padding(.bottom, 12)

            ProfileScreenContent(viewModel: session.profile)
        }
    }
}

#Preview {
    MainTabContainerView(session: SessionViewModel(), onLogout: {})
}
