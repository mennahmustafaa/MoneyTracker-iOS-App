//
//  ProfileViewModel.swift
//  MoneyTracker
//

import Combine
import Foundation

enum ProfileFinancialRowKind: String {
    case balance
    case income
    case expense
}

struct ProfileFinancialRow: Identifiable {
    let kind: ProfileFinancialRowKind
    let title: String
    let amount: Double

    var id: String { kind.rawValue }

    var assetName: String {
        switch kind {
        case .balance: return "walletIcon"
        case .income: return "transsIcon"
        case .expense: return "expenseeIcon"
        }
    }
}

struct ProfilePaymentRow: Identifiable {
    let name: String
    let amount: Double
    let assetName: String

    var id: String { name }
}

struct ProfileActivityRow: Identifiable {
    let id: String
    let title: String
    let value: String
    let assetName: String
}

struct ProfileSettingsRow: Identifiable {
    let id: String
    let title: String
    let assetName: String

    init(title: String, assetName: String) {
        self.id = title
        self.title = title
        self.assetName = assetName
    }
}

@MainActor
final class ProfileViewModel: ObservableObject {
    private let store: AppDataStore
    private var cancellables = Set<AnyCancellable>()
    private let onLogout: () -> Void

    let displayName = "Demo User"
    let email = "demo@budgettracker.com"
    let memberSince = "Member since Dec 2024"

    init(store: AppDataStore, onLogout: @escaping () -> Void) {
        self.store = store
        self.onLogout = onLogout
        store.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    var financialRows: [ProfileFinancialRow] {
        let s = store.budgetSummary
        return [
            ProfileFinancialRow(kind: .balance, title: "Total Balance", amount: s.currentBalance),
            ProfileFinancialRow(kind: .income, title: "Total Income", amount: s.income),
            ProfileFinancialRow(kind: .expense, title: "Total Expenses", amount: s.expenses)
        ]
    }

    var paymentRows: [ProfilePaymentRow] {
        store.paymentMethodTotals().map { pair in
            ProfilePaymentRow(name: pair.name, amount: pair.amount, assetName: Self.assetName(for: pair.name))
        }
    }

    var activityRows: [ProfileActivityRow] {
        let total = store.transactions.count
        let month = store.transactionCountThisMonth()
        return [
            ProfileActivityRow(id: "total", title: "Total Transactions", value: "\(total)", assetName: "totaltransIcon"),
            ProfileActivityRow(id: "month", title: "This Month", value: "\(month)", assetName: "totaltransIcon")
        ]
    }

    let settingsRows: [ProfileSettingsRow] = [
        ProfileSettingsRow(title: "Settings", assetName: "chartIcon"),
        ProfileSettingsRow(title: "Notifications", assetName: "heartIconn"),
        ProfileSettingsRow(title: "Privacy & Security", assetName: "trueIcon")
    ]

    func logout() {
        onLogout()
    }

    func openSettingsDetail() {}
    func openNotifications() {}
    func openPrivacy() {}

    private static func assetName(for paymentMethod: String) -> String {
        switch paymentMethod.lowercased() {
        case "card": return "transIcon"
        case "cash": return "plusIcon"
        case "wallet": return "walletIcon"
        default: return "transIcon"
        }
    }
}
