//
//  SectionCardView.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI

/// Reusable section with a bold title and a card-style container for content.
struct SectionCardView<Content: View>: View {
    let title: String
    let addShadow: Bool
    @ViewBuilder let content: () -> Content

    init(
        title: String,
        addShadow: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.addShadow = addShadow
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.arimo(size: 22, weight: .bold))
                .foregroundColor(.primaryText)
                .padding(.bottom, 12)

            content()
        }
        .modifier(CardStyle(shadow: addShadow))
    }
}

private struct CardStyle: ViewModifier {
    let shadow: Bool

    func body(content: Content) -> some View {
        let styled = content
            .background(Color.tabBarBackground)
            .cornerRadius(12)
        return Group {
            if shadow {
                styled
                    .shadow(color: Color.shadowBlack10, radius: 1, x: 0, y: 1)
                    .shadow(color: Color.shadowBlack10, radius: 1.5, x: 0, y: 1)
            } else {
                styled
            }
        }
    }
}
