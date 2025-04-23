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

    private var viewModel: PieChartViewModel {
        PieChartViewModel(transactions: transactions, selectedAngle: selectedAngle)
    }

    var body: some View {
        Chart(viewModel.groupedData, id: \.category) { entry in
            SectorMark(
                angle: .value("Amount", entry.total),
                innerRadius: .ratio(0.618),
                angularInset: 1
            )
            .cornerRadius(5)
            .foregroundStyle(by: .value("Category", entry.category.rawValue))
            .opacity(entry.category == viewModel.highlightedCategory ? 1 : 0.3)
        }
        .chartForegroundStyleScale(
            domain: viewModel.groupedData.map { $0.category.rawValue },
            range: viewModel.groupedData.map { $0.category.color }
        )
        .chartAngleSelection(value: $selectedAngle)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartLegend(position: .bottom, spacing: 12)
        .padding()
        .chartBackground { proxy in
            GeometryReader { geo in
                let frame = geo[proxy.plotFrame!]
                PieChartCenterLabel(category: viewModel.displayedCategory, frame: frame)
            }
        }
    }
}



#Preview {
    PieChartScreen()
}
