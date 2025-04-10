//
//  ExpenseDetailsSection.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.04.2025.
//

import SwiftUI

struct ExpenseDetailsSection: View {
    @Binding var viewModel: AddExpenseViewModel
    @FocusState.Binding  var isInputActive: Bool
    @AppStorage("selectedCurrency") var selectedCurrency: String = Locale.current.currencySymbol ?? "$"

    var body: some View {
        NavigationStack {
            TextField("Expense Name", text: $viewModel.name)
                .autocapitalization(.words)
                .scrollDismissesKeyboard(.immediately)
            TextField("Amount (\(selectedCurrency))", value: $viewModel.amount, formatter: amountFormatter)
                .focused($isInputActive)
                .keyboardType(.decimalPad)
        }
    }
    
     private var amountFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = Locale.current.groupingSeparator
        formatter.decimalSeparator = Locale.current.decimalSeparator
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter
    }
}
