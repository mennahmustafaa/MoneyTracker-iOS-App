//
//  BudgetChartsView.swift
//  MoneyTracker
//

import Charts
import SwiftUI

/// Analytics: monthly bar chart and spending donut (opened from Budget toolbar chart button).
struct BudgetChartsView: View {
    @Environment(\.dismiss) private var dismiss

    private struct MonthPoint: Identifiable {
        var id: String { label }
        let label: String
        let amount: Double
    }

    private struct CategorySlice: Identifiable {
        var id: String { name }
        let name: String
        let amount: Double
        let color: Color
    }

    private let monthlyPoints: [MonthPoint] = [
        MonthPoint(label: "Nov", amount: 0),
        MonthPoint(label: "Dec", amount: 0),
        MonthPoint(label: "Jan", amount: 0),
        MonthPoint(label: "Feb", amount: 5000),
        MonthPoint(label: "Mar", amount: 5000),
        MonthPoint(label: "Apr", amount: 950)
    ]

    private let categorySlices: [CategorySlice] = [
        CategorySlice(name: "Housing", amount: 4500, color: .chartCoral),
        CategorySlice(name: "Food", amount: 2800, color: .chartTeal),
        CategorySlice(name: "Fun", amount: 1200, color: .chartBlue),
        CategorySlice(name: "Transport", amount: 800, color: .chartOrange)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    monthlyCard
                    categoriesCard
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .background(Color.appBackground)
            .navigationTitle("Budget")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.inter(size: 17, weight: .semibold))
                }
            }
        }
    }

    private var monthlyCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 6) {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.formLabelMuted)
                Text("Monthly Comparison")
                    .font(.inter(size: 15, weight: .medium))
                    .foregroundColor(Color.formLabelMuted)
            }

            Chart(monthlyPoints) { point in
                BarMark(
                    x: .value("Month", point.label),
                    y: .value("Amount", point.amount)
                )
                .foregroundStyle(Color.chartCoral)
                .cornerRadius(6)
            }
            .chartYScale(domain: 0...6000)
            .chartXAxis {
                AxisMarks(preset: .aligned) { _ in
                    AxisValueLabel()
                        .font(.inter(size: 11))
                        .foregroundStyle(Color.formLabelMuted)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: [0, 1500, 3000, 4500, 6000]) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(Color.dividerLine)
                    AxisValueLabel()
                        .font(.inter(size: 11))
                        .foregroundStyle(Color.formLabelMuted)
                }
                AxisMarks(position: .trailing, values: [0, 1500, 3000, 4500, 6000]) { _ in
                    AxisValueLabel()
                        .font(.inter(size: 11))
                        .foregroundStyle(Color.formLabelMuted)
                }
            }
            .frame(height: 220)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.tabBarBackground)
        .cornerRadius(20)
        .shadow(color: Color.shadowBlack10, radius: 4, x: 0, y: 2)
    }

    private var categoriesCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 6) {
                Image(systemName: "chart.pie.fill")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.formLabelMuted)
                Text("Spending Categories")
                    .font(.inter(size: 15, weight: .medium))
                    .foregroundColor(Color.formLabelMuted)
            }

            Chart(categorySlices) { slice in
                SectorMark(
                    angle: .value("Amount", slice.amount),
                    innerRadius: .ratio(0.55),
                    angularInset: 1.5
                )
                .foregroundStyle(slice.color)
                .cornerRadius(4)
            }
            .frame(height: 200)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 10) {
                ForEach(categorySlices) { slice in
                    HStack(spacing: 8) {
                        Circle()
                            .fill(slice.color)
                            .frame(width: 8, height: 8)
                        Text(slice.name)
                            .font(.inter(size: 14))
                            .foregroundColor(.primaryText)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.tabBarBackground)
        .cornerRadius(20)
        .shadow(color: Color.shadowBlack10, radius: 4, x: 0, y: 2)
    }
}

#Preview {
    BudgetChartsView()
}
