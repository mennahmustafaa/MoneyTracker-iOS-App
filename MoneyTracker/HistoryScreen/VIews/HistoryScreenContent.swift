//
//  HistoryScreenContent.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI

/// History tab: scrollable content only (header, filter, transaction list). ScrollView and toolbar live in MainTabContainerView.
struct HistoryScreenContent: View {
    @StateObject private var viewModel: HistoryViewModel

    init(viewModel: HistoryViewModel? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel ?? HistoryViewModel())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            headerSection
            segmentControl
            transactionList
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }

    private var headerSection: some View {
        HStack(alignment: .center) {
            Text("History")
                .font(.arimo(size: 34, weight: .bold))
                .foregroundColor(.primaryText)
        }
        .padding(.leading, 19.9868)
        .padding(.trailing, 19.98682)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 70)
    }

    private var segmentControl: some View {
        HStack(spacing: 0) {
            ForEach(HistoryFilter.allCases, id: \.self) { filter in
                segmentButton(filter)
            }
        }
        .padding(2)
        .frame(height: 40)
        .background(Color.segmentTrackBackground)
        .cornerRadius(10)
    }

    private func segmentButton(_ filter: HistoryFilter) -> some View {
        let isSelected = viewModel.selectedFilter == filter
        return Button {
            viewModel.selectedFilter = filter
        } label: {
            Text(filter.rawValue)
                .font(.arimo(size: 13, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(isSelected ? .primaryText : .secondaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
        .background(isSelected ? Color.tabBarBackground : Color.clear)
        .cornerRadius(8)
        .shadow(color: isSelected ? Color.shadowBlack10 : .clear, radius: 1, x: 0, y: 1)
        .shadow(color: isSelected ? Color.shadowBlack10 : .clear, radius: 1.5, x: 0, y: 1)
    }

    private var transactionList: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.transactions.enumerated()), id: \.element.id) { index, transaction in
                HistoryRowView(
                    transaction: transaction,
                    onDelete: { viewModel.deleteTransaction(id: transaction.id) }
                )
                if index < viewModel.transactions.count - 1 {
                    Divider()
                        .background(Color.dividerLine)
                }
            }
        }
        .background(Color.tabBarBackground)
        .cornerRadius(12)
    }
}

#Preview("History content only") {
    ScrollView {
        HistoryScreenContent()
    }
    .background(Color.appBackground)
}

#Preview("History with tab bar") {
    HistoryViewWithToolbar()
}

/// History screen with tab bar: use when you need History + toolbar in one place (e.g. preview).
private struct HistoryViewWithToolbar: View {
    @State private var selectedTab: TabItem = .history

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                ScrollView {
                    HistoryScreenContent()
                        .padding(.bottom, TabBarView.height)
                }
                .frame(height: geo.size.height - TabBarView.height)
                .background(Color.appBackground)

                TabBarView(selectedTab: $selectedTab)
                    .frame(height: TabBarView.height)
            }
        }
    }
}
