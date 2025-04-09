//
//  BarChart.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.04.2025.
//

import SwiftUI
import Charts

struct BarChart: View {
    var groupedData: [(key: TransactionCategory, value: Double)]

    var body: some View {
        Chart(groupedData, id: \.key) { (category, totalAmount) in
            BarMark(
                x: .value("Category", category.rawValue),
                y: .value("Amount", totalAmount)
            )
            .foregroundStyle(category.color)
        }
        .padding()
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { _ in
                AxisGridLine()
                AxisValueLabel()
            }
        }
    }
}
