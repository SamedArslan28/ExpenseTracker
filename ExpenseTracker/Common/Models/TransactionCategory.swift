//
//  TransactionCategory.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 8.04.2025.
//

import SwiftUI

enum TransactionCategory: String, CaseIterable, Codable {

    case coffee = "Coffee"
    case food = "Food"
    case other = "Other"
    case shopping = "Shopping"
    case travel = "Travel"
    case entertainment = "Entertainment"
    case health = "Health"
    case education = "Education"
    case bills = "Bills"
    case transportation = "Transportation"
    case subscriptions = "Subscriptions"
    case groceries = "Groceries"
    case rent = "Rent"
    case gifts = "Gifts"
    case investments = "Investments"

    var iconName: String {
        switch self {
        case .coffee: return "cup.and.saucer.fill"
        case .food: return "fork.knife.circle.fill"
        case .shopping: return "bag.circle.fill"
        case .travel: return "airplane.circle.fill"
        case .other: return "ellipsis.circle.fill"
        case .entertainment: return "gamecontroller.fill"
        case .health: return "cross.case.fill"
        case .education: return "book.fill"
        case .bills: return "doc.text.fill"
        case .transportation: return "car.fill"
        case .subscriptions: return "rectangle.stack.badge.person.crop.fill"
        case .groceries: return "cart.fill"
        case .rent: return "house.fill"
        case .gifts: return "gift.fill"
        case .investments: return "chart.bar.fill"

        }
    }

    var color: Color {
        switch self {
        case .coffee: return .brown
        case .food: return .purple
        case .shopping: return .yellow
        case .travel: return .blue
        case .other: return .cyan
        case .entertainment: return .orange
        case .health: return .red
        case .education: return .indigo
        case .bills: return .teal
        case .transportation: return .cyan
        case .subscriptions: return .mint
        case .groceries: return .green
        case .rent: return .pink
        case .gifts: return .red.opacity(0.8)
        case .investments: return .blue.opacity(0.8)
        }
    }
}
