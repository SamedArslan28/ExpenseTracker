//
//  BaseTransaction.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 8.04.2025.
//

import Foundation

protocol BaseTransaction {
    var id: UUID { get }
    var name: String { get set }
    var date: Date { get set}
    var amount: Double { get set }
    var isExpense: Bool { get set }
    var category: TransactionCategory { get set }
}
