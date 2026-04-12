//
//  Color+Extensions.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI

/// App-wide color tokens (hex helpers, surfaces, charts, form fields).
extension Color {
    /// Creates a color from a hex string (e.g. "FFFFFF", "#000000"). Optional alpha 0...1.
    init(hex: String, alpha: Double = 1) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: alpha * Double(a) / 255
        )
    }

    // MARK: - Primary text colors
    static let primaryText = Color(hex: "0A0A0A")
    static let secondaryText = Color(hex: "8F8F94")
    static let whiteText = Color(hex: "FFFFFF")
    /// White at 60% opacity (e.g. "Current Balance" label on dark card)
    static let whiteOpacity60 = Color(hex: "FFFFFF", alpha: 0.6)
    /// White at 80% opacity (e.g. Income/Expenses labels on dark card)
    static let whiteOpacity80 = Color(hex: "FFFFFF", alpha: 0.8)

    // MARK: - Background colors
    static let appBackground = Color(hex: "F5F5F7")
    static let backgroundBlack = Color(hex: "000000")
    static let darkCardBackground = Color(hex: "1F1F1F")
    static let lightCardBackground = Color(hex: "F5F5F7")
    static let tabBarBackground = Color(hex: "FFFFFF")

    // MARK: - Card overlay (white 10%)
    static let cardOverlayWhite = Color(hex: "FFFFFF", alpha: 0.1)

    // MARK: - Accent colors (income/expense icons on budget card)
    static let incomeGreen = Color(hex: "5FE378")
    static let expenseRed = Color(hex: "E35F5F")
    /// Income amount text and icon tint (History)
    static let incomeGreenText = Color(red: 0.2, green: 0.78, blue: 0.35)
    /// Circle background for income (History row)
    static let incomeGreenTint = Color(red: 0.2, green: 0.78, blue: 0.35).opacity(0.1)
    /// Circle background for expense (History row)
    static let expenseRedTint = Color(red: 1, green: 0.23, blue: 0.19).opacity(0.1)

    // MARK: - Segment / filter track (History)
    static let segmentTrackBackground = Color(red: 0.9, green: 0.9, blue: 0.92)
    /// Shopping placeholder text (#8E8E93)
    static let shoppingPlaceholderText = Color(hex: "8E8E93")
    /// Shopping circle border stroke (#C7C7CC)
    static let shoppingCircleStroke = Color(hex: "C7C7CC")

    // MARK: - Donate colors
    static let donateTrackBackground = Color(hex: "E5E5EA")
    static let donateAccentRed = Color(hex: "FF3B30")
    static let donateAccentRedTint = Color(hex: "FF3B30", alpha: 0.1)

    // MARK: - Divider and progress
    static let dividerLine = Color(hex: "E6E6E6")
    static let progressBarFilled = Color(hex: "000000")
    static let progressBarUnfilled = Color(hex: "E6E6E6")

    // MARK: - Shadows (hex black with alpha)
    static let shadowBlack06 = Color(hex: "000000", alpha: 0.06)
    static let shadowBlack10 = Color(hex: "000000", alpha: 0.1)

    // MARK: - New Transaction sheet
    /// Input field fill `rgb(0.95, 0.95, 0.97)`
    static let formFieldFill = Color(red: 0.95, green: 0.95, blue: 0.97)
    /// Placeholder text `rgb(0.78, 0.78, 0.8)`
    static let formPlaceholder = Color(red: 0.78, green: 0.78, blue: 0.8)
    /// Muted label / unselected segment `rgb(0.56, 0.56, 0.58)`
    static let formLabelMuted = Color(red: 0.56, green: 0.56, blue: 0.58)

    // MARK: - Onboarding
    static let onboardingTitle = Color(red: 0.09, green: 0.09, blue: 0.09)
    static let onboardingSubtitle = Color(red: 0.32, green: 0.32, blue: 0.32)
    static let onboardingBullet = Color(red: 0.25, green: 0.25, blue: 0.25)
    static let onboardingFooter = Color(red: 0.45, green: 0.45, blue: 0.45)
    static let onboardingBenefitsFill = Color(red: 0.98, green: 0.98, blue: 0.98)
    static let onboardingSoftBorder = Color(red: 0.96, green: 0.96, blue: 0.96)
    static let onboardingIconGradientEnd = Color(red: 0.15, green: 0.15, blue: 0.15)
    static let onboardingIconGradientEndAlt = Color(red: 0.25, green: 0.25, blue: 0.25)

    // MARK: - Sign in
    static let signInTitle = Color(red: 0.09, green: 0.09, blue: 0.09)
    static let signInMuted = Color(red: 0.45, green: 0.45, blue: 0.45)
    static let signInPlaceholder = Color(red: 0.09, green: 0.09, blue: 0.09).opacity(0.5)
    static let signInFieldBorder = Color(red: 0.9, green: 0.9, blue: 0.9)
    static let signInOrText = Color(red: 0.63, green: 0.63, blue: 0.63)

    // MARK: - Budget charts
    static let chartCoral = Color(hex: "FF7067")
    static let chartTeal = Color(hex: "45C4B0")
    static let chartBlue = Color(hex: "5B9FED")
    static let chartOrange = Color(hex: "FF9F0A")
}
