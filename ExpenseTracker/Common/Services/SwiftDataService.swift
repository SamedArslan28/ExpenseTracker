//
//  SwiftDataService.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import SwiftData

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
            print("Failed to fetch expenses: \(error.localizedDescription)")
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
}
