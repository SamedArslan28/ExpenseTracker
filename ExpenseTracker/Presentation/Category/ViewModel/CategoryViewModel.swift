//
//  CategoryViewModel.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import SwiftUI

class CategoriesViewModel: ObservableObject {
    @Published private(set) var categoryTotals: [BalanceCategory: (expenses: Double, incomes: Double)] = [:]
    @Published var searchText: String = ""

    private var balanceItems: [BalanceItem]

    init(balanceItems: [BalanceItem]) {
        self.balanceItems = balanceItems
        calculateCategoryTotals()
    }

    private func calculateCategoryTotals() {
        var totals: [BalanceCategory: (expenses: Double, incomes: Double)] = [:]

        for item in balanceItems {
            let currentTotal = totals[item.category] ?? (expenses: 0, incomes: 0)
            if item.isExpense {
                totals[item.category] = (expenses: currentTotal.expenses + item.amount, incomes: currentTotal.incomes)
            } else {
                totals[item.category] = (expenses: currentTotal.expenses, incomes: currentTotal.incomes + item.amount)
            }
        }

        categoryTotals = totals
    }
}
