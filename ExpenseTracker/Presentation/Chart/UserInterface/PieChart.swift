//
//  PieChart.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.04.2025.
//

import Charts
import SwiftUI

struct PieChart: View {
    var groupedData: [(key: TransactionCategory, value: Double)]
    var totalExpense: Double

    var body: some View {
        Chart(groupedData, id: \.key) { (category, totalAmount) in
            SectorMark(
                angle: .value("Amount", totalAmount),
                innerRadius: .ratio(0.618),
                angularInset: 1.5
            )
            .foregroundStyle(category.color)
            .cornerRadius(5)
        }
        .chartLegend(alignment: .center, spacing: 18)
        .padding()
        .chartBackground { proxy in
            GeometryReader { geo in
                let frame = geo[proxy.plotFrame!]
                VStack {
                    Text("Total Expenses")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    Text("$\(totalExpense, specifier: "%.2f")")
                        .font(.title2.bold())
                }
                .position(x: frame.midX,
                          y: frame.midY)
            }
        }
    }
}
