//
//  TabBarView.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI

/// Bottom navigation destinations; keep in sync with `MainTabContainerView.screenContent(for:)`.
enum TabItem: Int, CaseIterable {
    case home
    case history
    case shopping
    case goals
    case donate
    case profile

    var title: String {
        switch self {
        case .home: return "Home"
        case .history: return "History"
        case .shopping: return "Shopping"
        case .goals: return "Goals"
        case .donate: return "Donate"
        case .profile: return "Profile"
        }
    }

    var systemImage: String {
        switch self {
        case .home: return "square.grid.2x2"
        case .history: return "dollarsign.square"
        case .shopping: return "cart"
        case .goals: return "target"
        case .donate: return "heart"
        case .profile: return "person.crop.circle"
        }
    }
}

/// Single tab icon + label; selection state comes from `TabBarView`.
struct TabBarItemView: View {
    let tab: TabItem
    let isSelected: Bool

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
    }
}

/// Single shared bottom toolbar for all tabs. Used by MainTabContainerView only; screens provide content only.
struct TabBarView: View {
    @Binding var selectedTab: TabItem

    /// Fixed height; container uses this to constrain ScrollView and pad content.
    static let height: CGFloat = 72

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                Button {
                    selectedTab = tab
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
        TabBarView(selectedTab: .constant(.home))
    }
}
