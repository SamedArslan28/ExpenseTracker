//
//  BalanceItem.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import Foundation
import SwiftData

@Model
class TransactionItem: BaseTransaction, Codable {
    @Attribute(.unique) var id: UUID
    var name: String
    var category: TransactionCategory
    var amount: Double
    var isExpense: Bool
    var date: Date

    static var getAll: FetchDescriptor<TransactionItem> {
        FetchDescriptor<TransactionItem>()
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

    enum CodingKeys: String, CodingKey {
        case id, name, category, amount, isExpense, date
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(category.rawValue, forKey: .category)
        try container.encode(amount, forKey: .amount)
        try container.encode(isExpense, forKey: .isExpense)
        try container.encode(date, forKey: .date)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        let categoryRawValue = try container.decode(String.self, forKey: .category)
        category = TransactionCategory(rawValue: categoryRawValue) ?? .other
        amount = try container.decode(Double.self, forKey: .amount)
        isExpense = try container.decode(Bool.self, forKey: .isExpense)
        date = try container.decode(Date.self, forKey: .date)
    }
}

// TODO: - Move this logic to related part

extension TransactionItem {
    static func convertToCSV(transactions: [TransactionItem]) -> String {
        var csvString = "id,name,category,amount,isExpense,isFixed,date,day\n"
        for transaction in transactions {
            let id = transaction.id.uuidString
            let name = transaction.name
            let category = transaction.category.rawValue
            let amount = transaction.amount
            let isExpense = transaction.isExpense ? "true" : "false"
            let date = ISO8601DateFormatter().string(from: transaction.date)
            let row = "\(id),\(name),\(category),\(amount),\(isExpense),\(date)\n"
            csvString.append(row)
        }
        return csvString
    }
}

