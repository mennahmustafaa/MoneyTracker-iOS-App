//
//  AppSessionContainer.swift
//  MoneyTracker
//
//  Owns one `AppDataStore` and all tab view models. Inject a Supabase-backed store here later.
//

import Combine
import Foundation

@MainActor
final class AppSessionContainer: ObservableObject {
    let store: AppDataStore
    let budget: BudgetViewModel
    let history: HistoryViewModel
    let shopping: ShoppingViewModel
    let goals: GoalsViewModel
    let donate: DonateViewModel
    let profile: ProfileViewModel

    init(session: SessionViewModel, onLogout: @escaping () -> Void) {
        let store = AppDataStore()
        self.store = store
        budget = BudgetViewModel(store: store)
        history = HistoryViewModel(store: store)
        shopping = ShoppingViewModel(store: store)
        goals = GoalsViewModel(store: store)
        donate = DonateViewModel(store: store)
        profile = ProfileViewModel(store: store, session: session, onLogout: onLogout)
    }
}
