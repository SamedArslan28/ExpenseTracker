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
    var amount: Double
    var isExpense: Bool
    var categoryRawValue: String
    var recurrence: RecurrenceRule
    var date: Date
    var nextDueDate: Date
    
    var category: TransactionCategory {
        get { TransactionCategory(rawValue: categoryRawValue) ?? .other }
        set { categoryRawValue = newValue.rawValue }
    }
    
    init(
        name: String,
        amount: Double,
        isExpense: Bool,
        category: TransactionCategory,
        recurrence: RecurrenceRule,
        startDate: Date
    ) {
        self.id = UUID()
        self.name = name
        self.amount = amount
        self.isExpense = isExpense
        self.categoryRawValue = category.rawValue
        self.recurrence = recurrence
        self.date = startDate
        self.nextDueDate = FixedTransaction.calculateNextDueDate(from: startDate, rule: recurrence)
    }
    
    static var getAll: FetchDescriptor<FixedTransaction> {
        FetchDescriptor<FixedTransaction>(sortBy: [SortDescriptor(\.nextDueDate)])
    }
    
    static func calculateNextDueDate(from date: Date, rule: RecurrenceRule) -> Date {
        let calendar = Calendar.current
        let components: DateComponents
        
        switch rule {
        case .daily:
            components = DateComponents(day: 1)
        case .weekly:
            components = DateComponents(weekOfYear: 1)
        case .monthly:
            components = DateComponents(month: 1)
        case .yearly:
            components = DateComponents(year: 1)
        }
        
        let adjustedDate = calendar.startOfDay(for: date)
        
        if date > Date() {
            return adjustedDate
        }
        
        var nextDate = adjustedDate
        while nextDate <= Date() {
            nextDate = calendar.date(byAdding: components, to: nextDate) ?? Date()
        }
        return nextDate
    }
    
    func advanceToNextDueDate() {
        self.nextDueDate = FixedTransaction.calculateNextDueDate(from: self.nextDueDate, rule: self.recurrence)
    }
}
