//
//  EditTransactionView.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 14.04.2025.
//


import SwiftUI

struct EditTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext

    @State private var name: String
    @State private var amount: Double
    @State private var date: Date
    @State private var isExpense: Bool
    @State private var selectedCategory: TransactionCategory

    var transaction: DefaultTransaction

    init(transaction: DefaultTransaction) {
        self.transaction = transaction
        _name = State(initialValue: transaction.name)
        _amount = State(initialValue: transaction.amount)
        _date = State(initialValue: transaction.date)
        _isExpense = State(initialValue: transaction.isExpense)
        _selectedCategory = State(initialValue: transaction.category)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    TextField("Name", text: $name)
                    TextField("Amount", value: $amount, format: .number)
                        .keyboardType(.decimalPad)

                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])

                    Toggle("Is Expense", isOn: $isExpense)

                    Picker("Category", selection: $selectedCategory) {
                        ForEach(TransactionCategory.allCases, id: \.rawValue) { category in
                            Text(category.rawValue)
                                .tag(category)
                        }
                    }
                }
            }
            .navigationTitle("Edit Transaction")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        updateTransaction()
                        dismiss()
                    }
                }
            }
        }
    }

    private func updateTransaction() {
        transaction.name = name
        transaction.amount = amount
        transaction.date = date
        transaction.isExpense = isExpense
        transaction.category = selectedCategory

        do {
            try modelContext.save()
        } catch {
            print("Failed to save transaction: \(error.localizedDescription)")
        }
    }
}
