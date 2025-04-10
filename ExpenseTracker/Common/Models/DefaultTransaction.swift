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
    var category: TransactionCategory
    var amount: Double
    var isExpense: Bool
    var date: Date

    static var getAll: FetchDescriptor<DefaultTransaction> {
        FetchDescriptor<DefaultTransaction>()
    }

    init(
        id: UUID = UUID(),
        name: String,
        category: TransactionCategory,
        amount: Double,
        isExpense: Bool,
        isFixed: Bool = false,
        date: Date,
        day: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.amount = amount
        self.isExpense = isExpense
        self.date = date
    }
}

