import SwiftUI

@Observable
class CategoriesViewModel {
    private(set) var categoryTotals: [TransactionCategory: (expenses: Double, incomes: Double)] = [:]
    var searchText: String = "" {
        didSet {
            filterCategories()
        }
    }

    private var balanceItems: [TransactionItem]
    private(set) var filteredCategories: [TransactionCategory] = TransactionCategory.allCases

    init(balanceItems: [TransactionItem]) {
        self.balanceItems = balanceItems
        calculateCategoryTotals()
        filterCategories() // Initialize filtered categories
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

    private func filterCategories() {
        if searchText.isEmpty {
            filteredCategories = TransactionCategory.allCases
        } else {
            filteredCategories = TransactionCategory.allCases.filter { $0.rawValue.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
