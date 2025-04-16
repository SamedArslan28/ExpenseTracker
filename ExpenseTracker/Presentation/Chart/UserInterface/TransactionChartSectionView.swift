//
//  TransactionChartSectionView.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.04.2025.
//

import SwiftUI
import Charts

enum ChartType: String, CaseIterable, Identifiable {
    case pie = "Pie Chart"
    case bar = "Bar Chart"

    var id: Self { self }
}

struct TransactionChartSectionView: View {
    let title: String
    let items: [any BaseTransaction]

    @State private var selectedChart: ChartType = .pie

    private var groupedData: [(key: TransactionCategory, value: Double)] {
        Dictionary(grouping: items.filter { $0.isExpense }, by: { $0.category })
            .map { (key: $0.key, value: $0.value.reduce(0) { $0 + $1.amount }) }
    }

    private var totalExpense: Double {
        items.filter { $0.isExpense }
            .reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        VStack(spacing: 16) {

            MonthlyExpense()
//            Text(title)
//                .font(.title2.bold())
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.horizontal)
//
//            Picker("Chart Type", selection: $selectedChart) {
//                ForEach(ChartType.allCases) { chart in
//                    Text(chart.rawValue).tag(chart)
//                }
//            }
//            .pickerStyle(.segmented)
//            .padding(.horizontal)
//
//            switch selectedChart {
//                case .pie:
//                    PieChart(
//                        groupedData: groupedData,
//                        totalExpense: totalExpense
//                    )
//                case .bar:
//                    BarChart(
//                        groupedData: groupedData
//                    )
//            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.thickMaterial)
        )
        .frame(height: 380)
        .padding(.horizontal)
    }
}


