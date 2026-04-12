//
//  Font+Extensions.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI
import UIKit

/// Typography helpers: Arimo/Inter when bundled, otherwise system fonts.
extension Font {
    /// Arimo font with system fallback for performance. Falls back to system font if Arimo isn't bundled.
    static func arimo(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        if UIFont(name: "Arimo", size: size) != nil {
            return .custom("Arimo", size: size).weight(weight)
        } else {
            return .system(size: size, weight: weight)
        }
    }

    /// Inter for Records section; falls back to system if not bundled.
    static func inter(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        if UIFont(name: "Inter", size: size) != nil {
            return .custom("Inter", size: size).weight(weight)
        }
        return .system(size: size, weight: weight)
    }
}
