//
//  FixedIncomeViewModel.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 29.01.2025.
//

import Foundation
import Observation

@Observable
final class FixedIncomeViewModel {
    var fixedItems: [TransactionItem] = []

    private let dataSource: SwiftDataService

    init(dataSource: SwiftDataService) {
        self.dataSource = dataSource
        fetchFixedItems()
    }

     func fetchFixedItems() {
         fixedItems = dataSource.fetchFixedExpenses()
    }

    func addFixedItem(_ item: TransactionItem) {
        dataSource.addExpense(item)
        fetchFixedItems()
    }

    func deleteItem(_ transactionItem: TransactionItem) {
        dataSource.deleteItem(item: transactionItem)
        fetchFixedItems()
    }
}
