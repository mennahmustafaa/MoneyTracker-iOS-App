//
//  Currency+Formatting.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import Foundation

/// Formats a number as dollar amount: "$" only, never "USD". Uses en_US for consistent grouping.
/// All amounts use exactly two fractional digits (e.g. `$0.00`, `$1,234.56`).
enum CurrencyFormat {
    private static let locale = Locale(identifier: "en_US")

    private static let decimalFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.locale = locale
        f.numberStyle = .decimal
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 2
        return f
    }()

    /// e.g. "$0.00", "$1,234.56"
    static func dollarString(from value: Double) -> String {
        let number = decimalFormatter.string(from: NSNumber(value: value)) ?? "0.00"
        return "$\(number)"
    }

    /// Same as `dollarString` — two decimal places. Kept for existing call sites.
    static func wholeDollarString(from value: Double) -> String {
        dollarString(from: value)
    }

    /// Signed amount for records, e.g. "-$140.00" or "+$600.00".
    static func signedWholeDollarString(from value: Double) -> String {
        let absStr = dollarString(from: abs(value))
        if value >= 0 {
            return "+\(absStr)"
        }
        return "-\(absStr)"
    }
}
