//
//  DonateComponents.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI

/// Hero quote on the Donate tab (gradient card).
struct DonateQuoteCardView: View {
    let quote: String
    let author: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(quote)
                .font(.arimo(size: 15).italic())
                .foregroundColor(.whiteText)
            Text(author)
                .font(.arimo(size: 13))
                .foregroundColor(.whiteOpacity60)
        }
        .padding(.horizontal, 16)
        .padding(.top, 25.20822)
        .padding(.bottom, 1.22407)
        .frame(maxWidth: .infinity, minHeight: 114, maxHeight: 114, alignment: .topLeading)
        .background(
            LinearGradient(
                stops: [
                    .init(color: Color(hex: "1A1A1A"), location: 0),
                    .init(color: Color(hex: "2E2E2E"), location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(20)
        .shadow(color: Color.shadowBlack10, radius: 3, x: 0, y: 4)
        .shadow(color: Color.shadowBlack10, radius: 7.5, x: 0, y: 10)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .inset(by: 0.61)
                .stroke(Color.whiteText.opacity(0.05), lineWidth: 1.22407)
        )
    }
}

/// Total donations plus org count and monthly average (black card).
struct DonateSummaryCardView: View {
    let total: Double
    let count: Int
    let monthlyAverage: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 7.99471) {
            Text("Total Donations")
                .font(.arimo(size: 13))
                .foregroundColor(.whiteOpacity60)
            Text(CurrencyFormat.dollarString(from: total))
                .font(.arimo(size: 40, weight: .bold))
                .foregroundColor(.whiteText)

            HStack(spacing: 16) {
                summarySmallCard(title: "Organizations", value: "\(count)", icon: "heart")
                summarySmallCard(
                    title: "Monthly",
                    value: CurrencyFormat.dollarString(from: monthlyAverage),
                    icon: "calendar"
                )
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.leading, 23.98416)
        .padding(.trailing, 23.98417)
        .padding(.top, 23.98416)
        .padding(.bottom, 0)
        .frame(maxWidth: .infinity, minHeight: 248.92647, maxHeight: 248.92647, alignment: .topLeading)
        .background(Color.backgroundBlack)
        .cornerRadius(20)
        .shadow(color: Color.shadowBlack10, radius: 3, x: 0, y: 4)
        .shadow(color: Color.shadowBlack10, radius: 7.5, x: 0, y: 10)
    }

    private func summarySmallCard(title: String, value: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 7.99474) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.donateAccentRed)
                Text(title)
                    .font(.arimo(size: 13))
                    .foregroundColor(.whiteOpacity80)
            }
            .frame(maxWidth: .infinity, minHeight: 30.00888, maxHeight: 30.00888, alignment: .leading)

            Text(value)
                .font(.arimo(size: 20, weight: .bold))
                .foregroundColor(.whiteText)
        }
        .padding(.horizontal, 15.98944)
        .padding(.top, 15.98941)
        .padding(.bottom, 0)
        .frame(maxWidth: .infinity, minHeight: 89.49112, maxHeight: 89.49112, alignment: .topLeading)
        .background(Color.cardOverlayWhite)
        .cornerRadius(16)
    }
}

/// One cause name, amount, and red progress bar.
struct ImpactCauseRowView: View {
    let cause: ImpactCause

    var body: some View {
        VStack(alignment: .leading, spacing: 7.99469) {
            HStack(alignment: .center) {
                Text(cause.name)
                    .font(.arimo(size: 17))
                    .foregroundColor(.primaryText)
                Spacer(minLength: 0)
                Text(CurrencyFormat.dollarString(from: cause.amount))
                    .font(.arimo(size: 15))
                    .foregroundColor(.secondaryText)
            }
            .frame(maxWidth: .infinity, minHeight: 25.49512, maxHeight: 25.49512)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.donateTrackBackground)
                    Capsule()
                        .fill(Color.donateAccentRed)
                        .frame(width: geo.size.width * cause.progress)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 3.99736, maxHeight: 3.99736)
        }
        .padding(.horizontal, 15.98944)
        .padding(.top, 11.99213)
        .padding(.bottom, 0)
        .frame(maxWidth: .infinity, minHeight: 61, maxHeight: 61, alignment: .topLeading)
    }
}

/// Past donation: org, amount, cause • date • frequency.
struct DonationRecordRowView: View {
    let donation: DonationRecord

    var body: some View {
        HStack(alignment: .center, spacing: 11.99208) {
            Circle()
                .fill(Color.donateAccentRedTint)
                .frame(width: 39.99272, height: 39.99272)
                .overlay(
                    Image(systemName: "heart.fill")
                        .font(.system(size: 17.99768))
                        .foregroundColor(.donateAccentRed)
                )

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(donation.organization)
                        .font(.arimo(size: 17))
                        .foregroundColor(.primaryText)
                    Spacer(minLength: 0)
                    Text(CurrencyFormat.dollarString(from: donation.amount))
                        .font(.arimo(size: 17, weight: .bold))
                        .foregroundColor(.donateAccentRed)
                }
                .frame(height: 25.49512, alignment: .leading)

                Text("\(donation.cause) • \(donation.date) • \(donation.frequency)")
                    .font(.arimo(size: 13))
                    .foregroundColor(.secondaryText)
                    .frame(height: 19.50864, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image("deleteIcon")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.shoppingPlaceholderText)
                .scaledToFit()
                .frame(width: 15.98944, height: 15.98944)
        }
        .padding(.leading, 15.98944)
        .padding(.trailing, 15.98942)
        .padding(.vertical, 0)
        .frame(maxWidth: .infinity, minHeight: 69, maxHeight: 69, alignment: .leading)
    }
}
