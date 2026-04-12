//
//  MainTabContainerView.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI

/// Single root container: one shared tab bar (fixed) + one ScrollView. Each tab shows only its content; no screen owns the toolbar.
/// To add a new screen: add a case to TabItem and a case below in `screenContent(for:)`.
/// View models are created lazily - only when their tab is first accessed.
struct MainTabContainerView: View {
    let onLogout: () -> Void

    @State private var selectedTab: TabItem = .home
    @StateObject private var budgetViewModel = BudgetViewModel()
    @State private var historyViewModel: HistoryViewModel?
    @State private var shoppingViewModel: ShoppingViewModel?
    @State private var goalsViewModel: GoalsViewModel?
    @State private var donateViewModel: DonateViewModel?
    @State private var profileViewModel: ProfileViewModel?

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                ScrollView {
                    screenContent(for: selectedTab)
                        .padding(.bottom, TabBarView.height)
                }
                .frame(height: geo.size.height - TabBarView.height)
                .background(Color.appBackground)

                TabBarView(selectedTab: $selectedTab)
                    .frame(height: TabBarView.height)
            }
        }
    }

    @ViewBuilder
    private func screenContent(for tab: TabItem) -> some View {
        switch tab {
        case .home:
            BudgetScreenContent(viewModel: budgetViewModel, selectedTab: $selectedTab)
        case .history:
            HistoryScreenContent(viewModel: lazyHistoryViewModel)
        case .shopping:
            ShoppingScreenContent(viewModel: lazyShoppingViewModel)
        case .goals:
            GoalsScreenContent(viewModel: lazyGoalsViewModel)
        case .donate:
            DonateScreenContent(viewModel: lazyDonateViewModel)
        case .profile:
            ProfileScreenContent(viewModel: lazyProfileViewModel)
        }
    }

    private var lazyHistoryViewModel: HistoryViewModel {
        if historyViewModel == nil {
            historyViewModel = HistoryViewModel()
        }
        return historyViewModel!
    }

    private var lazyShoppingViewModel: ShoppingViewModel {
        if shoppingViewModel == nil {
            shoppingViewModel = ShoppingViewModel()
        }
        return shoppingViewModel!
    }

    private var lazyGoalsViewModel: GoalsViewModel {
        if goalsViewModel == nil {
            goalsViewModel = GoalsViewModel()
        }
        return goalsViewModel!
    }

    private var lazyDonateViewModel: DonateViewModel {
        if donateViewModel == nil {
            donateViewModel = DonateViewModel()
        }
        return donateViewModel!
    }

    private var lazyProfileViewModel: ProfileViewModel {
        if profileViewModel == nil {
            profileViewModel = ProfileViewModel(onLogout: onLogout)
        }
        return profileViewModel!
    }

    private func placeholderScreen(title: String) -> some View {
        Text(title)
            .font(.arimo(size: 22, weight: .bold))
            .foregroundColor(.primaryText)
            .frame(maxWidth: .infinity, minHeight: 400)
            .background(Color.appBackground)
    }
}

#Preview {
    MainTabContainerView(onLogout: {})
}
