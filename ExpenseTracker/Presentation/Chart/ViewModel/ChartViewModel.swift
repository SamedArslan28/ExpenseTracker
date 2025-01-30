//
//  ChartViewModel.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 29.01.2025.
//

import Foundation

@Observable
final class ChartViewModel {
    var balanceItems: [TransactionItem] = []
    var groupedTransactions: [(key: TransactionCategory, value: Double)] = []

    private let dataSource: SwiftDataService

    init(dataSource: SwiftDataService) {
        self.dataSource = dataSource
        fetchItems()
    }

    /// Fetches transaction data from the data source
    func fetchItems() {
        balanceItems = dataSource.fetchExpenses()
        updateGroupedTransactions()
    }

    /// Groups transactions by category and calculates total amounts
    func updateGroupedTransactions() {
        groupedTransactions = Dictionary(grouping: balanceItems, by: { $0.category })
            .map { (key: $0.key, value: $0.value.reduce(0) { $0 + $1.amount }) }
    }

    /// Computes total expenses
    var totalExpense: Double {
        balanceItems.filter { $0.isExpense }.reduce(0) { $0 + $1.amount }
    }
}
