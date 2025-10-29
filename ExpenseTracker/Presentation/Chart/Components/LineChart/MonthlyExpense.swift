//
//  MonthlyExpense.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 29.10.2025.
//

import Foundation


struct MonthlyExpense: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Double
}
