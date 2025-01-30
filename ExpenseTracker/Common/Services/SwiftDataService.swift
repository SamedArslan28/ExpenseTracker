//
//  SwiftDataService.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import SwiftData
import Foundation

final class SwiftDataService {
    @MainActor
    static let shared: SwiftDataService = .init()

    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    private init() {
        do {
            self.modelContainer = try ModelContainer(for: TransactionItem.self)
            self.modelContext = modelContainer.mainContext
            self.deleteAllItems()
            self.addSampleDataIfNeeded()
        } catch {
            fatalError()
        }
    }

    func fetchExpenses() -> [TransactionItem] {

        let sortDescriptor = SortDescriptor(\TransactionItem.date, order: .forward)
        let predicate = #Predicate<TransactionItem> { transaction in
            transaction.isFixed != true
        }
        let fetchDescriptor = FetchDescriptor<TransactionItem>(predicate: predicate,
                                                               sortBy: [sortDescriptor])
        do {
            return try modelContext.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch expenses: \(error.localizedDescription)")
            return []
        }
    }

    func fetchFixedExpenses() -> [TransactionItem] {
        let predicate = #Predicate<TransactionItem> { transaction in
            transaction.isFixed == true
        }
        let fetchDescriptor = FetchDescriptor<TransactionItem>(predicate: predicate )
        do {
            return try modelContext.fetch(fetchDescriptor)
        } catch {
            logger.error("Error while fetching fixed expenses: \(error)")
            return []
        }
    }

    func addExpense(_ transaction: TransactionItem) {

        modelContext.insert(transaction)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save expense: \(error.localizedDescription)")
        }
    }

    func deleteAllItems() {
        do {
            try modelContext.delete(model: TransactionItem.self)
        } catch {
            fatalError("Error deleting user data. Application has stopped.")
        }
    }

    func deleteItem(item: TransactionItem) {
        modelContext.delete(item)
    }

    private func addSampleDataIfNeeded() {
        do {
            let existingItems = try modelContext.fetch(FetchDescriptor<TransactionItem>())
            if existingItems.isEmpty {
                print("Database is empty. Adding sample data...")
                for i in 1...100 {
                    let newItem = TransactionItem(
                        name: "Item \(i)",
                        category: .allCases.randomElement()!,
                        amount: Double.random(in: 10...500),
                        isExpense: .random(),
                        date: Date().addingTimeInterval(Double(i) * -86400) // Spread over the last 100 days
                    )
                    modelContext.insert(newItem)
                }
                try modelContext.save()
                print("Added 100 sample items.")
            } else {
                print("Database already contains data.")
            }
        } catch {
            print("Failed to add sample data: \(error.localizedDescription)")
        }
    }
}
