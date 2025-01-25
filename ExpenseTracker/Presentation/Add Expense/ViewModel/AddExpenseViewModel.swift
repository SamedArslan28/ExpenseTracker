//
//  AddExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 25.01.2025.
//

import Foundation
import Observation

@Observable
final class AddExpenseViewModel {
    private let dataSource: SwiftDataService

    init(dataSource: SwiftDataService) {
        self.dataSource = dataSource
    }

    func addExpense(transaction: TransactionItem) {
        dataSource.addExpense(transaction)
    }
}
