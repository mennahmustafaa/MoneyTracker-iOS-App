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

    private static let wholeFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.locale = locale
        f.numberStyle = .decimal
        f.maximumFractionDigits = 0
        f.minimumFractionDigits = 0
        return f
    }()

    /// Two decimal places; **sign before `$`** (e.g. `-$1,675.00`, `$0.00`), matching common US UI — not `$-1,675.00`.
    static func dollarString(from value: Double) -> String {
        let negative = value < 0
        let magnitude = abs(value)
        let body = decimalFormatter.string(from: NSNumber(value: magnitude)) ?? "0.00"
        return (negative ? "-" : "") + "$" + body
    }

    /// Whole dollars, grouped, no cents — e.g. `$600`, `$2,275`. Sign before `$` when negative.
    static func dollarStringWhole(from value: Double) -> String {
        let negative = value < 0
        let magnitude = abs(value)
        let body = wholeFormatter.string(from: NSNumber(value: magnitude)) ?? "0"
        return (negative ? "-" : "") + "$" + body
    }

    /// Same as `dollarString` — two decimal places. Kept for existing call sites.
    static func wholeDollarString(from value: Double) -> String {
        dollarString(from: value)
    }

    /// Signed list amounts: sign before `$`, e.g. `-$140` / `+$600` when whole dollars, else two decimals.
    static func signedWholeDollarString(from value: Double) -> String {
        let a = abs(value)
        let absStr = isWholeDollar(a) ? dollarStringWhole(from: a) : dollarString(from: a)
        if value > 0 { return "+\(absStr)" }
        if value < 0 { return "-\(absStr)" }
        return dollarString(from: 0)
    }

    /// True when `magnitude` has no sub-dollar fraction (within float tolerance).
    private static func isWholeDollar(_ magnitude: Double) -> Bool {
        let m = abs(magnitude)
        let fractional = m - floor(m + 1e-9)
        return fractional < 0.001
    }
}
