//
//  BudgetView.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI

/// Home tab: budget card, header actions, and recent records. ScrollView and tab bar live in `MainTabContainerView`.
struct BudgetScreenContent: View {
    @ObservedObject var viewModel: BudgetViewModel
    @Binding var selectedTab: TabItem
    @State private var showNewTransaction = false
    @State private var showBudgetCharts = false

    private var recordsSecondary: Color {
        Color(red: 0.56, green: 0.56, blue: 0.58)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            headerSection
            BudgetCardView(budgetSummary: viewModel.budgetSummary)
            recordsSection
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
        .padding(.bottom, 16)
        .sheet(isPresented: $showNewTransaction) {
            NewTransactionSheet(viewModel: viewModel)
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showBudgetCharts) {
            BudgetChartsView()
                .presentationDragIndicator(.visible)
        }
    }

    private var headerSection: some View {
        HStack(spacing: 12) {
            Text("Budget")
                .font(.arimo(size: 34, weight: .bold))
                .foregroundColor(.primaryText)
            Spacer(minLength: 8)
            Button {
                showBudgetCharts = true
            } label: {
                Image("chartIcon")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.whiteText)
                    .frame(width: 19.99219, height: 19.99219)
                    .frame(width: 32, height: 32)
                    .background(Color.backgroundBlack)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            Button {
                showNewTransaction = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.whiteText)
                    .frame(width: 32, height: 32)
                    .background(Color.backgroundBlack)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            Button {
                selectedTab = .profile
            } label: {
                Image(systemName: "person.circle")
                    .font(.system(size: 32, weight: .regular))
                    .foregroundColor(.primaryText)
            }
            .buttonStyle(.plain)
        }
    }

    private var recordsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Records")
                .font(.inter(size: 22, weight: .bold))
                .foregroundColor(.black)
            Text("Track all your transactions")
                .font(.inter(size: 13))
                .foregroundColor(recordsSecondary)
                .padding(.top, 4)

            VStack(spacing: 0) {
                ForEach(Array(viewModel.records.enumerated()), id: \.element.id) { index, record in
                    BudgetRecordRowView(record: record)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    if index < viewModel.records.count - 1 {
                        Divider()
                            .background(Color.dividerLine)
                            .padding(.leading, 76)
                    }
                }
            }
            .background(Color.tabBarBackground)
            .cornerRadius(12)
            .shadow(color: Color.shadowBlack10, radius: 1, x: 0, y: 1)
            .shadow(color: Color.shadowBlack10, radius: 1.5, x: 0, y: 1)
            .padding(.top, 16)

            Button {} label: {
                Text("View all \(viewModel.totalTransactionCount) transactions >")
                    .font(.inter(size: 13))
                    .foregroundColor(recordsSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 12)
        }
    }
}

#Preview {
    ScrollView {
        BudgetScreenContent(viewModel: BudgetViewModel(), selectedTab: .constant(.home))
    }
    .background(Color.appBackground)
}
