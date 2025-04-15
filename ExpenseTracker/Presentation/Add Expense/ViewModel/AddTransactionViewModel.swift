//
//  AddExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.04.2025.
//


import Foundation
import Observation

@Observable
class AddTransactionViewModel {
    var name: String = ""
    var selectedCategory: TransactionCategory = .coffee
    var amount: Double? = nil
    var transactionType: TransactionType = .expense
    var selectedDate: Date = .now

    var isSaveButtonEnabled: Bool {
        if let amount = amount, amount > 0 {
            return !name.isEmpty
        }
        return false
    }

    func reset() {
        name = ""
        amount = 0.0
        transactionType = .expense
        selectedCategory = .coffee
        selectedDate = .now
    }

    func createTransaction() -> DefaultTransaction? {
        guard let amount else { return nil }
        return DefaultTransaction(
            name: name,
            category: selectedCategory,
            amount: amount,
            isExpense: transactionType == .expense,
            date: selectedDate
        )
    }
}
