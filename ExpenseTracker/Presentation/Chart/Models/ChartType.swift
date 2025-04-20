//
//  ChartType.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 4/20/25.
//

import SwiftUI

enum ChartType: String, CaseIterable {
    case pie, bar, line, gauge, fixed

    var title: String {
        switch self {
        case .pie: "Pie Chart"
        case .bar: "Bar Chart"
        case .line: "Line Chart"
        case .gauge: "Budget Usage"
        case .fixed: "Fixed Transaction"
        }
    }

    var icon: String {
        switch self {
        case .pie: "chart.pie.fill"
        case .bar: "chart.bar.fill"
        case .line: "chart.line.uptrend.xyaxis"
        case .gauge: "gauge"
        case .fixed: "chart.line.flattrend.xyaxis"
        }
    }
}
