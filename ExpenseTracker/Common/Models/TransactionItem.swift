//
//  BalanceItem.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import SwiftData
import SwiftUI

@Model
class TransactionItem: Codable {
    @Attribute(.unique)
    var id: UUID
    var name: String
    var category: TransactionCategory
    var amount: Double
    var isExpense: Bool
    var isFixed: Bool
    var date: Date
    var day: Int?
    @Transient var isAnimating: Bool = false

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
        self.isFixed = isFixed
        self.date = date
        self.day = day
    }

    enum CodingKeys: String, CodingKey {
        case id, name, category, amount, isExpense, isFixed, date, day
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(category.rawValue, forKey: .category)
        try container.encode(amount, forKey: .amount)
        try container.encode(isExpense, forKey: .isExpense)
        try container.encode(isFixed, forKey: .isFixed)
        try container.encode(date, forKey: .date)
        try container.encodeIfPresent(day, forKey: .day)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        let categoryRawValue = try container.decode(String.self, forKey: .category)
        category = TransactionCategory(rawValue: categoryRawValue) ?? .other
        amount = try container.decode(Double.self, forKey: .amount)
        isExpense = try container.decode(Bool.self, forKey: .isExpense)
        isFixed = try container.decode(Bool.self, forKey: .isFixed)
        date = try container.decode(Date.self, forKey: .date)
        day = try container.decodeIfPresent(Int.self, forKey: .day)
    }
}

extension TransactionItem {
    static func convertToCSV(transactions: [TransactionItem]) -> String {
        var csvString = "id,name,category,amount,isExpense,isFixed,date,day\n"
        for transaction in transactions {
            let id = transaction.id.uuidString
            let name = transaction.name
            let category = transaction.category.rawValue
            let amount = transaction.amount
            let isExpense = transaction.isExpense ? "true" : "false"
            let isFixed = transaction.isFixed ? "true" : "false"
            let date = ISO8601DateFormatter().string(from: transaction.date)
            let day = transaction.day.map { "\($0)" } ?? ""
            let row = "\(id),\(name),\(category),\(amount),\(isExpense),\(isFixed),\(date),\(day)\n"
            csvString.append(row)
        }
        return csvString
    }
}


enum TransactionCategory: String, CaseIterable, Codable {
    case coffee = "Coffee"
    case food = "Food"
    case other = "Other"
    case shopping = "Shopping"
    case travel = "Travel"

    var iconName: String {
        switch self {
        case .travel: return "airplane.circle.fill"
        case .food: return "fork.knife.circle.fill"
        case .shopping: return "bag.circle.fill"
        case .other: return "ellipsis.circle.fill"
        case .coffee: return "cup.and.saucer.fill"
        }
    }

    var color: Color {
        switch self {
        case .travel: return .blue
        case .food: return .purple
        case .shopping: return .yellow
        case .other: return .gray
        case .coffee: return .brown
        }
    }
}
