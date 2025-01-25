//
//  TransactionsScrollViewModel.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import Foundation
import Observation

@Observable
final class TransactionsScrollViewModel {
    var balanceItems: [TransactionItem] = []

    private let dataSource: SwiftDataService

    init(dataSource: SwiftDataService) {
        self.dataSource = dataSource
        fetchItems()
    }

    func addSampleExpense(expense: TransactionItem) {
        dataSource.addExpense(expense)
        balanceItems = dataSource.fetchExpenses()
    }

    private func fetchItems() {
        balanceItems = dataSource.fetchExpenses()
    }

    private func createRandomTransaction() {
        let randomNames: [String] = ["Coffee", "Groceries", "Restaurant", "Transport", "Gym", "Subscription", "Shopping"]
        let randomCategories: [TransactionCategory] = TransactionCategory.allCases
        let randomAmounts: [Double] = [500, 1_000, 2_000, 3_500, 4_500, 7_500, 12_000]
        let randomIsExpense: Bool = .random()

        let name: String = randomNames.randomElement() ?? "Miscellaneous"
        let category: TransactionCategory = randomCategories.randomElement() ?? .coffee
        let amount: Double = randomAmounts.randomElement() ?? 1_000
        let date: Date = .init()
        addSampleExpense(expense: TransactionItem(name: name, category: category, amount: amount, isExpense: randomIsExpense, date: date))
    }
}
