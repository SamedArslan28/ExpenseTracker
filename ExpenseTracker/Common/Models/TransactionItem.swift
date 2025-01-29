//
//  BalanceItem.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import SwiftData
import SwiftUI

@Model
class TransactionItem {
    @Attribute(.unique)
    var id: UUID

    var name: String
    var category: TransactionCategory
    var amount: Double
    var isExpense: Bool
    var isFixed: Bool = false
    var date: Date
    var day: Int?

    init(
        name: String,
        category: TransactionCategory,
        amount: Double,
        isExpense: Bool,
        isFixed: Bool = false,
        date: Date,
        day: Int? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.amount = amount
        self.isExpense = isExpense
        self.isFixed = isFixed
        self.date = date
        self.day = day
    }
}

enum TransactionCategory: String, CaseIterable, Codable {
    case coffee = "coffee"
    case food = "food"
    case other = "other"
    case shopping = "shopping"
    case travel = "travel"

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


