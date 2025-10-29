//
//  MonthlyExpense.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 29.10.2025.
//


import Foundation
import SwiftData

struct MonthlyExpense: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Double
}

@Observable
class LineChartViewModel {
    
    var transactions: [DefaultTransaction] = [] {
        didSet {
            updateComputedData()
        }
    }
    
    var selectedRange: DateRangeOption = .week {
        didSet {
            updateComputedData()
        }
    }
    
    private(set) var monthlyTotals: [MonthlyExpense] = []
    private(set) var dailyTotals: [DefaultTransaction] = []
    
    private var filteredTransactions: [DefaultTransaction] {
        transactions.filter { $0.date >= selectedRange.fromDate && $0.isExpense }
    }
    
    init(selectedRange: DateRangeOption = .week) {
        self.selectedRange = selectedRange
    }
    
    private func updateComputedData() {
        if selectedRange == .year {
            calculateMonthlyTotals()
        } else {
            calculateDailyTotals()
        }
    }

    private func calculateMonthlyTotals() {
        let calendar = Calendar.current
        
        let groups = Dictionary(grouping: filteredTransactions) { transaction in
            calendar.dateComponents([.year, .month], from: transaction.date)
        }

        self.monthlyTotals = groups.compactMap { (components, transactions) -> MonthlyExpense? in
            guard let date = calendar.date(from: components) else { return nil }
            let total = transactions.reduce(0) { $0 + $1.amount }
            return MonthlyExpense(date: date, amount: total)
        }
        .sorted { $0.date < $1.date }
        
        self.dailyTotals = []
    }
    
    private func calculateDailyTotals() {
        let calendar = Calendar.current
        let endDate = calendar.startOfDay(for: Date())
        let startDate = selectedRange.fromDate

        let totalsByDay = Dictionary(grouping: filteredTransactions) { transaction in
            calendar.startOfDay(for: transaction.date)
        }.mapValues { transactions in
            transactions.reduce(0) { $0 + $1.amount }
        }

        var allDataPoints = [DefaultTransaction]()
        var currentDate = startDate
        
        while currentDate <= endDate {
            let day = calendar.startOfDay(for: currentDate)
            let total = totalsByDay[day] ?? 0.0
            
            allDataPoints.append(
                DefaultTransaction(
                    name: "DailyTotal",
                    category: .other,
                    amount: total,
                    isExpense: true,
                    date: day
                )
            )
            
            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDay
        }
        
        self.dailyTotals = allDataPoints
        self.monthlyTotals = []
    }
}