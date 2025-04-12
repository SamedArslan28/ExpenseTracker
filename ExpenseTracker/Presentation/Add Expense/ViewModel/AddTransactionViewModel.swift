//
//  AddExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.04.2025.
//

import Combine
import Foundation
import Observation


@Observable
class AddTransactionViewModel: ObservableObject {
     var name: String = ""
     var selectedCategory: TransactionCategory = .coffee
    var amount: Double = 0.0
     var transactionType: TransactionType = .expense
     var selectedDate: Date = .now
     var isShowingSuccessAlert: Bool = false

    var isSaveButtonEnabled: Bool {
        guard amount > 0 else { return false }
        return !name.isEmpty
    }

    func reset() {
        name = ""
        amount = 0.0
        transactionType = .expense
        selectedCategory = .coffee
        selectedDate = .now
    }

    func createTransaction() -> DefaultTransaction? {
        return DefaultTransaction(
            name: name,
            category: selectedCategory,
            amount: amount,
            isExpense: transactionType == .expense,
            date: selectedDate
        )
    }
}
