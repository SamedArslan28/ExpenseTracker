//
//  BalanceItem.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import Foundation
import SwiftData



@Model
class DefaultTransaction: BaseTransaction {
    @Attribute(.unique) var id: UUID
    var name: String
    var amount: Double
    var isExpense: Bool
    var date: Date
    var categoryRawValue: String
    var category: TransactionCategory {
        get { TransactionCategory(rawValue: categoryRawValue) ?? .other }
        set { categoryRawValue = newValue.rawValue }
    }

    static var getAll: FetchDescriptor<DefaultTransaction> {
        FetchDescriptor<DefaultTransaction>()
    }

    static func filter(by category: TransactionCategory) -> Predicate<DefaultTransaction> {
        #Predicate { $0.categoryRawValue == category.rawValue }
    }

    init(
        id: UUID = UUID(),
        name: String,
        category: TransactionCategory,
        amount: Double,
        isExpense: Bool,
        date: Date
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.isExpense = isExpense
        self.date = date
        self.categoryRawValue = category.rawValue 
    }
}
