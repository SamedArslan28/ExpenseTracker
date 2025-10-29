//
//  RecurrenceRule.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 29.10.2025.
//



enum RecurrenceRule: String, Codable, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
}