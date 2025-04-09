//
//  FixedTransaction.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 8.04.2025.
//

import Foundation
import SwiftData

@Model
class FixedTransaction: BaseTransaction {

    @Attribute(.unique)
    var id: UUID
    var name: String
    var date: Date
    var amount: Double
    var day: Int
    var isExpense: Bool
    var category: TransactionCategory

    init(id: UUID, name: String, date: Date, amount: Double, day: Int, isExpense: Bool, category: TransactionCategory) {
        self.id = id
        self.name = name
        self.date = date
        self.amount = amount
        self.day = day
        self.isExpense = isExpense
        self.category = category
    }

    static var getAll: FetchDescriptor<FixedTransaction> {
        FetchDescriptor<FixedTransaction>()
    }
}


