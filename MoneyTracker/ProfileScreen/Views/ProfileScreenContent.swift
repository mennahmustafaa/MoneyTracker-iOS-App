//
//  ProfileScreenContent.swift
//  MoneyTracker
//

import SwiftUI

/// Profile tab: user card, finances, payments, activity, settings, log out. Tab bar is provided by `MainTabContainerView`.
@MainActor
struct ProfileScreenContent: View {
    @ObservedObject var viewModel: ProfileViewModel

    private let rowDivider = Color(red: 0.9, green: 0.9, blue: 0.92)
    private let mutedAmount = Color(red: 0.56, green: 0.56, blue: 0.58)
    private let expenseTint = Color(red: 1, green: 0.23, blue: 0.19)
    private let incomeTint = Color(red: 0.2, green: 0.78, blue: 0.35)

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Profile")
                .font(.inter(size: 34, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)

            profileHeaderCard

            sectionTitle("Financial Overview")
            financialOverviewCard

            sectionTitle("Payment Methods")
            paymentMethodsCard

            sectionTitle("Activity")
            activityCard

            sectionTitle("Settings")
            settingsCard

            logoutButton
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.inter(size: 22, weight: .bold))
            .foregroundColor(.black)
    }

    private var profileHeaderCard: some View {
        HStack(alignment: .center, spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 64, height: 64)
                Image(systemName: "person.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(Color.whiteText)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.displayName)
                    .font(.inter(size: 22, weight: .semibold))
                    .foregroundColor(.whiteText)
                Text(viewModel.email)
                    .font(.inter(size: 15))
                    .foregroundColor(.whiteText.opacity(0.6))
                Text(viewModel.memberSince)
                    .font(.inter(size: 13))
                    .foregroundColor(.whiteText.opacity(0.4))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.backgroundBlack)
        .cornerRadius(16)
        .shadow(color: Color.shadowBlack10, radius: 3, x: 0, y: 4)
        .shadow(color: Color.shadowBlack10, radius: 7.5, x: 0, y: 10)
    }

    private var financialOverviewCard: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.financialRows.enumerated()), id: \.element.id) { index, row in
                financialRow(row)
                if index < viewModel.financialRows.count - 1 {
                    Divider()
                        .background(rowDivider)
                        .padding(.leading, 68)
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.leading, 16)
        .padding(.trailing, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.tabBarBackground)
        .cornerRadius(12)
        .shadow(color: Color.shadowBlack10, radius: 1, x: 0, y: 1)
        .shadow(color: Color.shadowBlack10, radius: 1.5, x: 0, y: 1)
    }

    private func financialRow(_ row: ProfileFinancialRow) -> some View {
        let (bg, amountColor): (Color, Color) = {
            switch row.kind {
            case .balance:
                return (.black, .black)
            case .income:
                return (incomeTint, incomeTint)
            case .expense:
                return (expenseTint, expenseTint)
            }
        }()

        return HStack(alignment: .center, spacing: 12) {
            ZStack {
                Circle()
                    .fill(bg)
                    .frame(width: 40, height: 40)
                profileAssetImage(row.assetName, size: 20, templateColor: .whiteText)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(row.title)
                    .font(.inter(size: 13))
                    .foregroundColor(mutedAmount)
                Text(CurrencyFormat.dollarString(from: row.amount))
                    .font(.inter(size: 20, weight: .semibold))
                    .foregroundColor(amountColor)
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 8)
    }

    private var paymentMethodsCard: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.paymentRows.enumerated()), id: \.element.id) { index, row in
                HStack(spacing: 12) {
                    profileAssetImage(row.assetName, size: 22, templateColor: .primaryText)
                        .frame(width: 28, alignment: .center)
                    Text(row.name)
                        .font(.inter(size: 17))
                        .foregroundColor(.black)
                    Spacer()
                    Text(CurrencyFormat.dollarString(from: row.amount))
                        .font(.inter(size: 17, weight: .semibold))
                        .foregroundColor(mutedAmount)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                if index < viewModel.paymentRows.count - 1 {
                    Divider()
                        .background(rowDivider)
                        .padding(.leading, 56)
                }
            }
        }
        .background(Color.tabBarBackground)
        .cornerRadius(12)
        .shadow(color: Color.shadowBlack10, radius: 1, x: 0, y: 1)
        .shadow(color: Color.shadowBlack10, radius: 1.5, x: 0, y: 1)
    }

    private var activityCard: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.activityRows.enumerated()), id: \.element.id) { index, row in
                HStack(spacing: 12) {
                    profileAssetImage(row.assetName, size: 20, templateColor: .primaryText)
                        .frame(width: 24)
                    Text(row.title)
                        .font(.inter(size: 17))
                        .foregroundColor(.black)
                    Spacer()
                    Text(row.value)
                        .font(.inter(size: 17, weight: .semibold))
                        .foregroundColor(mutedAmount)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                if index < viewModel.activityRows.count - 1 {
                    Divider()
                        .background(rowDivider)
                        .padding(.leading, 52)
                }
            }
        }
        .background(Color.tabBarBackground)
        .cornerRadius(12)
        .shadow(color: Color.shadowBlack10, radius: 1, x: 0, y: 1)
        .shadow(color: Color.shadowBlack10, radius: 1.5, x: 0, y: 1)
    }

    private var settingsCard: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.settingsRows.enumerated()), id: \.element.id) { index, row in
                Button {
                    switch index {
                    case 0: viewModel.openSettingsDetail()
                    case 1: viewModel.openNotifications()
                    default: viewModel.openPrivacy()
                    }
                } label: {
                    HStack(spacing: 12) {
                        profileAssetImage(row.assetName, size: 20, templateColor: .primaryText)
                            .frame(width: 24)
                        Text(row.title)
                            .font(.inter(size: 17))
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(mutedAmount)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                if index < viewModel.settingsRows.count - 1 {
                    Divider()
                        .background(rowDivider)
                        .padding(.leading, 52)
                }
            }
        }
        .background(Color.tabBarBackground)
        .cornerRadius(12)
        .shadow(color: Color.shadowBlack10, radius: 1, x: 0, y: 1)
        .shadow(color: Color.shadowBlack10, radius: 1.5, x: 0, y: 1)
    }

    private var logoutButton: some View {
        Button {
            viewModel.logout()
        } label: {
            Text("Log out")
                .font(.inter(size: 17, weight: .semibold))
                .foregroundColor(.whiteText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(expenseTint)
                .cornerRadius(12)
        }
        .buttonStyle(.plain)
        .padding(.top, 4)
    }

    /// Catalog images: template tint when `templateColor` is set (good for single-color PNGs).
    @ViewBuilder
    private func profileAssetImage(_ name: String, size: CGFloat, templateColor: Color?) -> some View {
        if let templateColor {
            Image(name)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: size, height: size)
                .foregroundStyle(templateColor)
        } else {
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        }
    }
}

#Preview {
    ScrollView {
        ProfileScreenContent(viewModel: ProfileViewModel(store: AppDataStore.preview, onLogout: {}))
    }
    .background(Color.appBackground)
}
