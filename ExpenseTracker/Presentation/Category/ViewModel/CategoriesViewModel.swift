//
//  CategoryViewModel.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import SwiftUI


@Observable
class CategoriesViewModel {
    private(set) var categoryTotals: [TransactionCategory: (expenses: Double, incomes: Double)] = [:]
    var searchText: String = ""

    private var balanceItems: [TransactionItem]

    init(balanceItems: [TransactionItem]) {
        self.balanceItems = balanceItems
        calculateCategoryTotals()
    }

    private func calculateCategoryTotals() {
        var totals: [TransactionCategory: (expenses: Double, incomes: Double)] = [:]

        for item in balanceItems {
            let currentTotal: (expenses: Double, incomes: Double) = totals[item.category] ?? (expenses: 0, incomes: 0)
            if item.isExpense {
                totals[item.category] = (expenses: currentTotal.expenses + item.amount, incomes: currentTotal.incomes)
            } else {
                totals[item.category] = (expenses: currentTotal.expenses, incomes: currentTotal.incomes + item.amount)
            }
        }
        categoryTotals = totals
    }
}
