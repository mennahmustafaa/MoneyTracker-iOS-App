//
//  TabBarView.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI

/// Bottom navigation destinations; keep in sync with `MainTabContainerView.screenContent(for:)`. Profile opens from the Budget header only.
enum TabItem: Int, CaseIterable {
    case home
    case history
    case shopping
    case goals
    case donate

    var title: String {
        switch self {
        case .home: return "Home"
        case .history: return "History"
        case .shopping: return "Shopping"
        case .goals: return "Goals"
        case .donate: return "Donate"
        }
    }

    var systemImage: String {
        switch self {
        case .home: return "square.grid.2x2"
        case .history: return "dollarsign.square"
        case .shopping: return "cart"
        case .goals: return "target"
        case .donate: return "heart"
        }
    }
}

/// Single tab icon + label; selection state comes from `TabBarView`.
struct TabBarItemView: View {
    let tab: TabItem
    let isSelected: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var selectionAnimation: Animation {
        reduceMotion ? .easeOut(duration: 0.001) : AppMotion.tab
    }

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: tab.systemImage)
                .font(.system(size: 22, weight: .regular))
                .foregroundColor(isSelected ? .primaryText : .secondaryText)
                .padding(8)
                .background(isSelected ? Color.lightCardBackground : Color.clear)
                .cornerRadius(10)
            Text(tab.title)
                .font(.arimo(size: 11))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .foregroundColor(isSelected ? .primaryText : .secondaryText)
        }
        .frame(maxWidth: .infinity)
        .animation(selectionAnimation, value: isSelected)
    }
}

/// Single shared bottom toolbar for all tabs. Used by MainTabContainerView only; screens provide content only.
struct TabBarView: View {
    let selectedTab: TabItem
    /// Deferred via `Task` in the button so selection does not mutate parent `@State` during SwiftUI’s layout/update pass (avoids “Modifying state during view update”).
    let onSelectTab: (TabItem) -> Void

    /// Fixed height; container uses this to constrain ScrollView and pad content.
    static let height: CGFloat = 72

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                Button {
                    let next = tab
                    Task { @MainActor in
                        onSelectTab(next)
                    }
                } label: {
                    TabBarItemView(tab: tab, isSelected: selectedTab == tab)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.tabBarBackground)
        .shadow(color: Color.shadowBlack06, radius: 8, x: 0, y: -2)
    }
}

#Preview {
    VStack {
        Spacer()
        TabBarView(selectedTab: .home, onSelectTab: { _ in })
    }
}
