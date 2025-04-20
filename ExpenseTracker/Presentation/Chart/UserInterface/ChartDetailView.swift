//
//  ChartDetailView.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 4/20/25.
//

import SwiftUI

import SwiftUI

struct ChartDetailView: View {
    @State var selectedDateRange: DateRangeOption = .week
    let chartType: ChartType

    var body: some View {
        VStack {
            DateRangePickerView(selectedRange: $selectedDateRange)
            chartView(for: chartType, selectedRange: selectedDateRange)
        }
        .navigationTitle(chartType.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    func chartView(for type: ChartType, selectedRange: DateRangeOption) -> some View {
        switch type {
            case .pie:
                PieChartScreen()
            case .bar:
                BarChartScreen(selectedRange: selectedDateRange)
            case .line:
                BarChartScreen(selectedRange: selectedDateRange)
            case .gauge:
                BarChartScreen(selectedRange: selectedDateRange)
            case .fixed:
                BarChartScreen(selectedRange: selectedDateRange)
        }
    }
}
