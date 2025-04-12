//
//  DatePickerSection.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.04.2025.
//

import SwiftUI

struct DatePickerSection: View {
    @Binding var viewModel: AddTransactionViewModel

    var body: some View {
        Section(header: Text("Date")) {
            DatePicker(
                "Select Expense Date",
                selection: $viewModel.selectedDate,
                in: ...Date(),
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
        }
    }
}
