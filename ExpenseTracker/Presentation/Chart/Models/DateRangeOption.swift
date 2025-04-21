//
//  DateRangeOption.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 4/20/25.
//

import SwiftUI

enum DateRangeOption: String, CaseIterable {
    case week = "Last 7 Days"
    case month = "Last 30 Days"
    case year = "This Year"

    var calendarComponent: Calendar.Component {
        switch self {
            case .week, .month:
                return .day
            case .year:
                return .month
        }
    }

    var fromDate: Date {
        let calendar = Calendar.current
        let now = Date()
        switch self {
            case .week:
                return calendar.date(byAdding: .day, value: -8, to: now) ?? now
            case .month:
                return calendar.date(byAdding: .day, value: -31, to: now) ?? now
            case .year:
                return calendar.date(byAdding: .day, value: -361, to: now) ?? now
        }
    }

    var dateFormat: String {
        switch self {
            case .week:
                return "EEEE MMM d"
            case .month:
                return "d MMM yyyy"
            case .year:
                return "MMM yyyy"
        }
    }
}

