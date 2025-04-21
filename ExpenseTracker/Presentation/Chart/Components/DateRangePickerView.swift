//
//  DateRangePickerView.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 4/21/25.
//

import SwiftUI

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
