//
//  ProfileViewModel.swift
//  MoneyTracker
//

import Combine
import Foundation

enum ProfileFinancialRowKind {
    case balance
    case income
    case expense
}

struct ProfileFinancialRow: Identifiable {
    let id = UUID()
    let title: String
    let amount: Double
    let kind: ProfileFinancialRowKind

    var assetName: String {
        switch kind {
        case .balance: return "walletIcon"
        case .income: return "transsIcon"
        case .expense: return "expenseeIcon"
        }
    }
}

struct ProfilePaymentRow: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let assetName: String
}

struct ProfileActivityRow: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    /// Name of image set in `Assets.xcassets`.
    let assetName: String
}

struct ProfileSettingsRow: Identifiable {
    let id = UUID()
    let title: String
    let assetName: String
}

@MainActor
/// Profile tab: demo user snapshot, settings list, and log out (returns to onboarding via `onLogout`).
final class ProfileViewModel: ObservableObject {
    let displayName = "Demo User"
    let email = "demo@budgettracker.com"
    let memberSince = "Member since Dec 2024"

    let financialRows: [ProfileFinancialRow] = [
        ProfileFinancialRow(title: "Total Balance", amount: 6055, kind: .balance),
        ProfileFinancialRow(title: "Total Income", amount: 10_600, kind: .income),
        ProfileFinancialRow(title: "Total Expenses", amount: 4545, kind: .expense)
    ]

    let paymentRows: [ProfilePaymentRow] = [
        ProfilePaymentRow(name: "Card", amount: 14_235, assetName: "transIcon"),
        ProfilePaymentRow(name: "Cash", amount: 265, assetName: "plusIcon"),
        ProfilePaymentRow(name: "Wallet", amount: 645, assetName: "walletIcon")
    ]

    let activityRows: [ProfileActivityRow] = [
        ProfileActivityRow(title: "Total Transactions", value: "20", assetName: "totaltransIcon"),
        ProfileActivityRow(title: "This Month", value: "13", assetName: "totaltransIcon")
    ]

    let settingsRows: [ProfileSettingsRow] = [
        ProfileSettingsRow(title: "Settings", assetName: "chartIcon"),
        ProfileSettingsRow(title: "Notifications", assetName: "heartIconn"),
        ProfileSettingsRow(title: "Privacy & Security", assetName: "trueIcon")
    ]

    private let onLogout: () -> Void

    init(onLogout: @escaping () -> Void) {
        self.onLogout = onLogout
    }

    func logout() {
        onLogout()
    }

    func openSettingsDetail() {}
    func openNotifications() {}
    func openPrivacy() {}
}
