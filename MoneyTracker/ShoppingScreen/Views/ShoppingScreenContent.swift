//
//  ShoppingScreenContent.swift
//  MoneyTracker
//
//  Created by Mennah on 16/02/2026.
//

import SwiftUI

/// Shopping tab: content-only screen (header, list type segment, add row, items list). ScrollView and toolbar are owned by MainTabContainerView.
struct ShoppingScreenContent: View {
    @StateObject private var viewModel: ShoppingViewModel

    init(viewModel: ShoppingViewModel? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel ?? ShoppingViewModel())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerSection
            segmentControl
            addItemRow
            itemsCard
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }

    private var headerSection: some View {
        Text("Shopping")
            .font(.arimo(size: 34, weight: .bold))
            .foregroundColor(.primaryText)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 70)
    }

    private var segmentControl: some View {
        HStack(spacing: 0) {
            ForEach(ShoppingSegment.allCases, id: \.self) { segment in
                Button {
                    viewModel.selectedSegment = segment
                } label: {
                    Text(segment.rawValue)
                        .font(.arimo(size: 13, weight: .bold))
                        .foregroundColor(
                            viewModel.selectedSegment == segment ? .primaryText : .shoppingPlaceholderText
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.plain)
                .background(
                    viewModel.selectedSegment == segment ? Color.tabBarBackground : Color.clear
                )
                .cornerRadius(8)
            }
        }
        .padding(2)
        .frame(width: 358, height: 40, alignment: .topLeading)
        .background(Color.segmentTrackBackground)
        .cornerRadius(10)
    }

    private var addItemRow: some View {
        HStack(spacing: 8) {
            TextField("Add item...", text: $viewModel.draftItemText)
                .font(.arimo(size: 17))
                .foregroundColor(.primaryText)
                .tint(.primaryText)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity, minHeight: 43.99008, maxHeight: 43.99008)
                .background(Color.appBackground)
                .cornerRadius(10)

            Button(action: viewModel.addItem) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.backgroundBlack)
                        .frame(width: 43.99008, height: 43.99008)
                    Image("plusIcon")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.whiteText)
                        .scaledToFit()
                        .frame(width: 19.9868, height: 19.9868)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 15.98944)
        .padding(.top, 15.98944)
        .padding(.bottom, 0)
        .frame(maxWidth: .infinity, minHeight: 77.42254, maxHeight: 77.42254, alignment: .topLeading)
        .background(Color.tabBarBackground)
        .cornerRadius(12)
        .shadow(color: Color.shadowBlack10, radius: 1, x: 0, y: 1)
        .shadow(color: Color.shadowBlack10, radius: 1.5, x: 0, y: 1)
    }

    private var itemsCard: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.filteredItems.enumerated()), id: \.element.id) { index, item in
                ShoppingItemRowView(
                    item: item,
                    onToggle: { viewModel.toggleItem(item) },
                    onDelete: { viewModel.deleteItem(item) }
                )
                if index < viewModel.filteredItems.count - 1 {
                    Divider().background(Color.dividerLine)
                }
            }
        }
        .background(Color.tabBarBackground)
        .cornerRadius(12)
    }
}

#Preview {
    ScrollView {
        ShoppingScreenContent()
    }
    .background(Color.appBackground)
}
