//
//  ChartType.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 4/20/25.
//

import SwiftUI

enum ChartType: String, CaseIterable {
    case pie, line, fixed

    var title: String {
        switch self {
        case .pie: "Pie Chart"
        case .line: "Line Chart"
        case .fixed: "Fixed Transaction"
        }
    }

    var icon: String {
        switch self {
        case .pie: "chart.pie.fill"
        case .line: "chart.line.uptrend.xyaxis"
        case .fixed: "chart.line.flattrend.xyaxis"
        }
    }
}
