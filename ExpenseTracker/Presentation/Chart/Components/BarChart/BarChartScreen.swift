//
//  BarChart.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.04.2025.
//

import SwiftData
import SwiftUI

struct BarChartScreen: View {
    // MARK: - PROPERTIES

    @Query(DefaultTransaction.getAll) var transactions: [DefaultTransaction]
    @State private var selectedCategory: TransactionCategory = .coffee
    @State var selectedRange: DateRangeOption = .week

    private var filteredTransactions: [DefaultTransaction] {
        transactions.filter { $0.date >= selectedRange.fromDate && $0.category == selectedCategory }
    }

    // MARK: - BODY

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DateRangePickerView(selectedRange: $selectedRange)
            CategoryPicker(selectedCategory: $selectedCategory)
            BarChartView(
                transactions: filteredTransactions,
                selectedRange: selectedRange
            )
        }
        .padding()
        .frame(alignment: .top)
    }
}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: DefaultTransaction.self, configurations: config)
        let context = container.mainContext
        let mockData = DefaultTransaction.mockTransactions
        for transaction in mockData {
            context.insert(transaction)
        }
        return BarChartScreen()
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview container: \(error.localizedDescription)")
    }
}


