//
//  BalanceItem.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import SwiftData
import SwiftUICore

@Model
class TransactionItem {
    @Attribute(.unique)
    var id: UUID

    var name: String
    var category: TransactionCategory
    var amount: Double
    var isExpense: Bool
    var date: Date

    init(
        name: String,
        category: TransactionCategory,
        amount: Double,
        isExpense: Bool,
        date: Date
    ) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.amount = amount
        self.isExpense = isExpense
        self.date = date
    }
}

enum TransactionCategory: String, CaseIterable, Codable {
    case coffee = "coffee"
    case food = "food"
    case income = "income"
    case other = "other"
    case shopping = "shopping"
    case travel = "travel"

    var iconName: String {
        switch self {
        case .travel: return "airplane.circle.fill"
        case .food: return "fork.knife.circle.fill"
        case .income: return "dollarsign.circle.fill"
        case .shopping: return "bag.circle.fill"
        case .other: return "ellipsis.circle.fill"
        case .coffee: return "cup.and.saucer.fill"
        }
    }

    var color: Color {
        switch self {
        case .travel: return .blue
        case .food: return .purple
        case .income: return .green
        case .shopping: return .yellow
        case .other: return .gray
        case .coffee: return .brown
        }
    }
}
