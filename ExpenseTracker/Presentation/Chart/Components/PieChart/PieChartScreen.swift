//
//  PieChart.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.04.2025.
//

import Charts
import SwiftData
import SwiftUI

struct PieChartScreen: View {
    @Query(DefaultTransaction.getAll) var transactions: [DefaultTransaction]
    @State private var selectedAngle: Double?

    var groupedData: [(category: TransactionCategory, total: Double)] {
        let grouped = Dictionary(grouping: transactions, by: { $0.category })
        let mapped = grouped.map { (category, items) in
            (category, items.reduce(0) { $0 + $1.amount })
        }
        return mapped.sorted { $0.1 > $1.1 }.prefix(5).map { $0 }
    }

    var angleRanges: [(category: TransactionCategory, range: Range<Double>)] {
        var cumulative = 0.0
        return groupedData.map { (category, total) in
            let newCumulative = cumulative + total
            let range = cumulative..<newCumulative
            cumulative = newCumulative
            return (category, range)
        }
    }

    var selectedCategory: (category: TransactionCategory, total: Double)? {
        guard let selectedAngle else { return nil }
        for (index, angleRange) in angleRanges.enumerated() {
            if angleRange.range.contains(selectedAngle) {
                return groupedData[index]
            }
        }
        return nil
    }

    var displayedCategory: (category: TransactionCategory, total: Double)? {
        selectedCategory ?? groupedData.first
    }

    var body: some View {
        Chart(groupedData, id: \.category) { entry in
            SectorMark(
                angle: .value("Amount", entry.total),
                innerRadius: .ratio(0.618),
                angularInset: 1
            )
            .cornerRadius(5)
            .foregroundStyle(entry.category.color)
            .opacity(entry.category == (selectedCategory?.category ?? groupedData.first?.category) ? 1 : 0.3)
        }
        .chartAngleSelection(value: $selectedAngle)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartLegend(position: .bottom, spacing: 12)
        .padding()
        .chartBackground { proxy in
            GeometryReader { geo in
                let frame = geo[proxy.plotFrame!]
                VStack(spacing: 4) {
                    if let displayed = displayedCategory {
                        Text(displayed.category.rawValue)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        Text("$\(displayed.total, specifier: "%.2f")")
                            .font(.title2.bold())
                    }
                }
                .position(x: frame.midX, y: frame.midY)
            }
        }
    }
}

#Preview {
    PieChartScreen()
}
