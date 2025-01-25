//
//  SwiftDataService.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import SwiftData
import Foundation

class SwiftDataService {
    @MainActor
    static let shared: SwiftDataService = .init()

    private let modelContainer: ModelContainer?
    private let modelContext: ModelContext?

    @MainActor
    private init() {
        do {
            self.modelContainer = try ModelContainer(
                for: TransactionItem.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: false)
            )
            self.modelContext = modelContainer?.mainContext
            deleteAllItems()
        } catch {
            print("Failed to initialize ModelContainer: \(error.localizedDescription)")
            self.modelContainer = nil
            self.modelContext = nil
        }
    }

    func fetchExpenses() -> [TransactionItem] {
        guard let modelContext else {
            print("ModelContext is not available.")
            return []
        }
        do {
            return try modelContext.fetch(FetchDescriptor<TransactionItem>())
        } catch {
            print("Faialed to fetch expenses: \(error.localizedDescription)")
            return []
        }
    }

    func addExpense(_ transaction: TransactionItem) {
        guard let modelContext else {
            print("ModelContext is not available.")
            return
        }
        modelContext.insert(transaction)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save expense: \(error.localizedDescription)")
        }
    }

    func deleteAllItems() {
        do {
            try modelContext?.delete(model: TransactionItem.self)
        } catch {
            fatalError("Error deleting user data. Application has stopped.")
        }
    }

    private func addSampleDataIfNeeded() {
            guard let modelContext else { return }

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
