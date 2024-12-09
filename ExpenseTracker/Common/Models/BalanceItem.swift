//
//  BalanceItem.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import Foundation
import SwiftUICore

struct BalanceItem: Identifiable {
    let id: UUID = UUID()
    let name: String
    let category: BalanceCategory
    let amount: Double
    let isExpense: Bool
    let date: Date = .now
}

enum BalanceCategory: String, CaseIterable {
    case travel, food, income, shopping, other, coffee

    var iconName: String {
        switch self {
            case .travel: return "airplane.circle.fill"
            case .food: return "fork.knife.circle.fill"
            case .income: return "dollarsign.circle.fill"
            case .shopping: return "bag.circle.fill"
            case .other: return "ellipsis.circle.fill"
            case .coffee: return "custom.cup.and.saucer.circle.fill"
        }
    }

    var color: Color {
        switch self {
            case .travel: return .blue
            case .food: return .purple
            case .income: return .green
            case .shopping: return .yellow
            case .other : return .gray
            case .coffee: return .brown
        }
    }
}
