//
//  FixedTransaction.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 8.04.2025.
//

import Foundation
import SwiftData

@Model
class FixedTransaction: BaseTransaction, Codable {

    @Attribute(.unique)
    var id: UUID
    var name: String
    var date: Date
    var amount: Double
    var day: Int
    var isExpense: Bool
    var category: TransactionCategory

    enum CodingKeys: CodingKey {
        case _id
        case _name
        case _date
        case _amount
        case _day
        case _isExpense
        case _category
    }

    init(id: UUID, name: String, date: Date, amount: Double, day: Int, isExpense: Bool, category: TransactionCategory) {
        self.id = id
        self.name = name
        self.date = date
        self.amount = amount
        self.day = day
        self.isExpense = isExpense
        self.category = category
    }

    required init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: ._id)
        name = try container.decode(String.self, forKey: ._name)
        date = try container.decode(Date.self, forKey: ._date)
        amount = try container.decode(Double.self, forKey: ._amount)
        day = try container.decode(Int.self, forKey: ._day)
        isExpense = try container.decode(Bool.self, forKey: ._isExpense)
        category = try container.decode(TransactionCategory.self, forKey: ._category)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: ._id)
        try container.encode(name, forKey: ._name)
        try container.encode(date, forKey: ._date)
        try container.encode(amount, forKey: ._amount)
        try container.encode(day, forKey: ._day)
        try container.encode(isExpense, forKey: ._isExpense)
        try container.encode(category, forKey: ._category)
    }

    static var getAll: FetchDescriptor<FixedTransaction> {
        FetchDescriptor<FixedTransaction>()
    }
}


