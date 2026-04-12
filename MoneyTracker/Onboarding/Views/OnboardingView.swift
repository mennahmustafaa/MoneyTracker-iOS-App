//
//  OnboardingView.swift
//  MoneyTracker
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    private let gridColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerSection
                    .padding(.top, 12)
                featureGrid
                    .padding(.top, 28)
                benefitsSection
                    .padding(.top, 24)
                footerSection
                    .padding(.top, 28)
                    .padding(.bottom, 32)
            }
            .padding(.horizontal, 24)
        }
        .background(Color.appBackground)
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            logoView
            Text("MoneyTrack")
                .font(.inter(size: 36, weight: .bold))
                .kerning(0.37)
                .foregroundColor(Color.onboardingTitle)
                .multilineTextAlignment(.center)
            Text("Where money makes sense")
                .font(.inter(size: 18))
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
            .frame(width: 112, height: 112)
            .shadow(color: .black.opacity(0.12), radius: 24, x: 0, y: 8)
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
    }

    private var featureGrid: some View {
        LazyVGrid(columns: gridColumns, spacing: 16) {
            ForEach(viewModel.features) { feature in
                OnboardingFeatureCard(feature: feature)
            }
        }
    }

    private var benefitsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
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
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.onboardingBenefitsFill)
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .inset(by: 0.75)
                .stroke(Color.onboardingSoftBorder, lineWidth: 1.5)
        )
    }

    private var footerSection: some View {
        VStack(spacing: 16) {
            Button {
                viewModel.completeOnboarding()
            } label: {
                ZStack {
                    Capsule()
                        .fill(Color.onboardingTitle)
                    Capsule()
                        .fill(
                            LinearGradient(
                                stops: [
                                    .init(color: .white.opacity(0), location: 0),
                                    .init(color: .white.opacity(0.12), location: 0.5),
                                    .init(color: .white.opacity(0), location: 1)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    Text("Get Started")
                        .font(.inter(size: 17, weight: .semibold))
                        .foregroundColor(.whiteText)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
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
        VStack(spacing: 18) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(iconGradient)
                    .frame(width: 64, height: 64)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 4)
                Image(feature.assetName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.whiteText)
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            }
            Text(feature.title)
                .font(.inter(size: 16, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.onboardingTitle)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 22)
        .background(Color.white.opacity(0.8))
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 4)
        .shadow(color: .black.opacity(0.1), radius: 7.5, x: 0, y: 10)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .inset(by: 0.75)
                .stroke(Color.onboardingSoftBorder, lineWidth: 1.5)
        )
    }
}

#Preview {
    OnboardingView(viewModel: OnboardingViewModel())
}
