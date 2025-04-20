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
}

struct DateRangePickerView: View {
    @Binding  var selectedRange: DateRangeOption
    var body: some View {
        Picker("Date Range", selection: $selectedRange.animation(.easeInOut)) {
            ForEach(DateRangeOption.allCases, id: \.self) {
                Text($0.rawValue)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
}
