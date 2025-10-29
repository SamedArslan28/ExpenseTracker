//
//  FixedTransactionChartViewModel.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 29.10.2025.
//


import Foundation
import SwiftData

struct ProjectedDataPoint: Identifiable {
    let id = UUID()
    var date: Date
    var amount: Double
}

@Observable
class FixedTransactionChartViewModel {
    
    // MARK: - Inputs
    var transactions: [FixedTransaction] = [] {
        didSet { updateComputedData() }
    }
    
    var selectedRange: DateRangeOption = .month {
        didSet { updateComputedData() }
    }
    
    // MARK: - Outputs
    private(set) var chartData: [ProjectedDataPoint] = []
    var rawSelectedDate: Date? = nil
    
    var isChartDataEmpty: Bool {
        !chartData.contains { $0.amount > 0 }
    }
    
    var selectedData: ProjectedDataPoint? {
        guard let rawSelectedDate else { return nil }
        let granularity = selectedRange.calendarComponent
        
        return chartData.first {
            Calendar.current.isDate($0.date, equalTo: rawSelectedDate, toGranularity: granularity)
        }
    }
    
    // MARK: - Init
    init(selectedRange: DateRangeOption = .month) {
        self.selectedRange = selectedRange
    }

    // MARK: - Main Logic
    
    func updateComputedData() {
        if selectedRange == .year {
            calculateMonthlyProjections()
        } else {
            calculateDailyProjections()
        }
    }
    
    private func calculateDailyProjections() {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        let endDate = selectedRange.endDate
        
        var dailyTotals = [Date: Double]()
        var currentDate = startDate
        while currentDate <= endDate {
            dailyTotals[currentDate] = 0.0
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        for transaction in transactions {
            var nextDate = transaction.nextDueDate
            
            while nextDate <= endDate {
                let day = calendar.startOfDay(for: nextDate)
                if dailyTotals[day] != nil {
                    dailyTotals[day]! += transaction.amount
                }
                nextDate = getNextDate(for: nextDate, with: transaction.recurrence)
            }
        }
        
        self.chartData = dailyTotals.map { (date, amount) in
            ProjectedDataPoint(date: date, amount: amount)
        }.sorted { $0.date < $1.date }
    }
    
    private func calculateMonthlyProjections() {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        let endDate = selectedRange.endDate
        
        var monthlyTotals = [Date: Double]()
        var currentDate = startDate
        while currentDate <= endDate {
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
            monthlyTotals[startOfMonth] = 0.0
            currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
        }
        
        // Use `transactions` directly (no filtering)
        for transaction in transactions {
            var nextDate = transaction.nextDueDate
            
            while nextDate <= endDate {
                let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: nextDate))!
                
                if monthlyTotals[startOfMonth] != nil {
                    monthlyTotals[startOfMonth]! += transaction.amount
                }
                nextDate = getNextDate(for: nextDate, with: transaction.recurrence)
            }
        }
        
        self.chartData = monthlyTotals.map { (date, amount) in
            ProjectedDataPoint(date: date, amount: amount)
        }.sorted { $0.date < $1.date }
    }
    
    private func getNextDate(for date: Date, with rule: RecurrenceRule) -> Date {
        let calendar = Calendar.current
        let components: DateComponents
        
        switch rule {
        case .daily: components = DateComponents(day: 1)
        case .weekly: components = DateComponents(weekOfYear: 1)
        case .monthly: components = DateComponents(month: 1)
        case .yearly: components = DateComponents(year: 1)
        }
        
        return calendar.date(byAdding: components, to: date) ?? Date()
    }
}
