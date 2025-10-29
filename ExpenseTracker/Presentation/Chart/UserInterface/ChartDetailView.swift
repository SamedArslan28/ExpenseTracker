//
//  ChartDetailView.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 4/20/25.
//

import SwiftUI

struct ChartDetailView: View {
    let chartType: ChartType

    var body: some View {
        VStack {
            chartView(for: chartType)
        }
        .navigationTitle(chartType.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    func chartView(for type: ChartType) -> some View {
        switch type {
            case .pie:
                PieChartScreen()
            case .line:
                LineChartScreen()
            case .fixed:
                FixedTransactionChartScreen()
        }
    }
}

#Preview {
    ChartDetailView(chartType: .line)
}
