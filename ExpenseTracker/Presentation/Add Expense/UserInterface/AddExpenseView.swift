//
//  SaveView.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import SwiftUI

struct AddExpenseView: View {
    let categories: [TransactionCategory] = TransactionCategory.allCases

    @State private var name: String = ""
    @State private var selectedCategory: TransactionCategory = .income
    @State private var amount: String = ""
    @State private var isExpense: Bool = false

    var body: some View {
        VStack {
            Form {
                Section("Expense Detail") {
                    TextField("Name", text: $name)
                        .autocapitalization(.words)
                        .textFieldStyle(RoundedTextFieldStyle())
                }

                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        HStack(spacing: 4) {
                            Label {
                                Text(category.rawValue.capitalized)
                                    .foregroundStyle(.red)
                            } icon: {
                                Image(systemName: category.iconName)
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(category.color)
                            }
                        }
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
            }

            Button(action: saveExpense) {
                Text("Save Expense")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(name.isEmpty || amount.isEmpty || Double(amount) == 0 ? Color.gray : Color.blue)
                    .cornerRadius(10)
                    .padding()
            }
            .disabled(name.isEmpty || amount.isEmpty || Double(amount) == 0)
        }
        .tint(.black)
    }

    private func saveExpense() {
        guard let amountValue = Double(amount) else { return }
        _ = TransactionItem(
            name: name,
            category: selectedCategory,
            amount: amountValue,
            isExpense: isExpense,
            date: .now
        )
    }
}

#Preview {
    AddExpenseView()
}
