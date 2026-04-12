//
//  OnboardingView.swift
//  MoneyTracker
//

import SwiftUI

@MainActor
struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    var onGetStarted: () -> Void

    private let gridColumns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        VStack(spacing: 0) {
            headerSection
            featureGrid
                .padding(.top, 22)
            benefitsSection
                .padding(.top, 22)
            footerSection
                .padding(.top, 24)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 24)
        .padding(.top, 14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.appBackground)
    }

    private var headerSection: some View {
        VStack(spacing: 5) {
            logoView
            Text("MoneyTrack")
                .font(.inter(size: 34, weight: .bold))
                .kerning(0.35)
                .foregroundColor(Color.onboardingTitle)
                .multilineTextAlignment(.center)
            Text("Where money makes sense")
                .font(.inter(size: 17))
                .foregroundColor(Color.onboardingSubtitle)
                .multilineTextAlignment(.center)
            Text("Track it. Own it.")
                .font(.inter(size: 20, weight: .bold))
                .foregroundColor(Color.onboardingTitle)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private var logoView: some View {
        Image("logo")
            .resizable()
            .scaledToFit()
            .frame(width: 96, height: 96)
            .shadow(color: .black.opacity(0.12), radius: 18, x: 0, y: 8)
            .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
    }

    private var featureGrid: some View {
        LazyVGrid(columns: gridColumns, spacing: 14) {
            ForEach(viewModel.features) { feature in
                OnboardingFeatureCard(feature: feature)
            }
        }
    }

    private var benefitsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(viewModel.benefitLines.enumerated()), id: \.offset) { _, line in
                HStack(alignment: .center, spacing: 12) {
                    Circle()
                        .fill(Color.onboardingTitle.opacity(0.75))
                        .frame(width: 8, height: 8)
                    Text(line)
                        .font(.inter(size: 14))
                        .foregroundColor(Color.onboardingBullet)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.onboardingBenefitsFill)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .inset(by: 0.75)
                .stroke(Color.onboardingSoftBorder, lineWidth: 1.5)
        )
    }

    private var footerSection: some View {
        VStack(spacing: 16) {
            Button {
                onGetStarted()
            } label: {
                Text("Get Started")
                    .font(.inter(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.black)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .shadow(color: .black.opacity(0.13), radius: 12, x: 0, y: 8)

            Text("Join thousands making smarter money decisions")
                .font(.inter(size: 14))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.onboardingFooter)
        }
    }
}

// MARK: - Feature card

private struct OnboardingFeatureCard: View {
    let feature: OnboardingFeature

    private var iconGradient: LinearGradient {
        let end = feature.useAltIconGradient
            ? Color.onboardingIconGradientEndAlt
            : Color.onboardingIconGradientEnd
        return LinearGradient(
            stops: [
                .init(color: Color.onboardingTitle, location: 0),
                .init(color: end, location: 1)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(iconGradient)
                    .frame(width: 60, height: 60)
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                    .shadow(color: .black.opacity(0.08), radius: 5, x: 0, y: 4)
                Image(feature.assetName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.whiteText)
                    .scaledToFit()
                    .frame(width: 28, height: 28)
            }
            Text(feature.title)
                .font(.inter(size: 15, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.onboardingTitle)
                .lineLimit(1)
                .minimumScaleFactor(0.88)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 18)
        .background(Color.white.opacity(0.8))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 4)
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 8)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .inset(by: 0.75)
                .stroke(Color.onboardingSoftBorder, lineWidth: 1.5)
        )
    }
}

#Preview {
    OnboardingView(viewModel: OnboardingViewModel(), onGetStarted: {})
}
