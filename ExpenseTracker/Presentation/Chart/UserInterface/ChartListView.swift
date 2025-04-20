//
//  ChartListView.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 4/20/25.
//

import SwiftUI

struct ChartListView: View {
    @State private var selectedChart: ChartType?
    var body: some View {
        List {
            ForEach(ChartType.allCases, id: \.self) { chart in
                NavigationLink(value: chart) {
                    ChartListRowView(chart: chart)
                }
            }
        }
        .navigationTitle("Charts")
        .navigationDestination(for: ChartType.self) { chart in
            ChartDetailView(chartType: chart)
        }
    }
}
