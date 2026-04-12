//
//  DonateScreenContent.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI

/// Donate tab: content-only screen (header, quote, summary, causes, donation history). Shared toolbar is owned by MainTabContainerView.
struct DonateScreenContent: View {
    @StateObject private var viewModel: DonateViewModel
    @State private var showNewDonation = false

    init(viewModel: DonateViewModel? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel ?? DonateViewModel())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerSection
            DonateQuoteCardView(quote: viewModel.quote, author: viewModel.quoteAuthor)
            DonateSummaryCardView(
                total: viewModel.totalDonations,
                count: viewModel.totalDonationsCount,
                monthlyAverage: viewModel.monthlyAverage
            )
            impactSection
            historySection
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 16)
        .sheet(isPresented: $showNewDonation) {
            NewDonationSheet(viewModel: viewModel)
                .presentationDragIndicator(.hidden)
        }
    }

    private var headerSection: some View {
        HStack {
            Text("Donate")
                .font(.arimo(size: 34, weight: .bold))
                .foregroundColor(.primaryText)
            Spacer()
            Button {
                showNewDonation = true
            } label: {
                ZStack {
                    Circle().fill(Color.backgroundBlack)
                    Image(systemName: "plus")
                        .font(.system(size: 19.9868, weight: .bold))
                        .foregroundColor(.whiteText)
                }
                .frame(width: 34, height: 34)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, minHeight: 70, maxHeight: 70, alignment: .center)
    }

    private var impactSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Impact by Cause")
                .font(.arimo(size: 22, weight: .bold))
                .foregroundColor(.primaryText)
                .padding(.bottom, 8)

            VStack(spacing: 0) {
                ForEach(Array(viewModel.causes.enumerated()), id: \.element.id) { index, cause in
                    ImpactCauseRowView(cause: cause)
                    if index < viewModel.causes.count - 1 {
                        Divider().background(Color.dividerLine)
                    }
                }
            }
            .background(Color.tabBarBackground)
            .cornerRadius(12)
        }
    }

    private var historySection: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.donations.enumerated()), id: \.element.id) { index, donation in
                DonationRecordRowView(donation: donation)
                if index < viewModel.donations.count - 1 {
                    Divider().background(Color.dividerLine)
                }
            }
        }
        .background(Color.tabBarBackground)
        .cornerRadius(12)
    }
}

#Preview {
    ScrollView {
        DonateScreenContent()
    }
    .background(Color.appBackground)
}
