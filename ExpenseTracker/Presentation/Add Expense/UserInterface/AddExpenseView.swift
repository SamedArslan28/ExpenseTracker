import SwiftUI
import os

struct AddExpenseView: View {
    @AppStorage("selectedCurrency") private var selectedCurrency: String = Locale.current.currencySymbol ?? "$"
    @State private var name: String = ""
    @State private var selectedCategory: TransactionCategory = .other
    @State private var amount: String = ""
    @State private var isExpense: Bool = false
    @FocusState private var focusedField: Field?

    let categories: [TransactionCategory] = TransactionCategory.allCases
    let viewModel: AddExpenseViewModel = .init(dataSource: .shared)

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Expense Details").font(.headline)) {
                        TextField("Expense Name", text: $name)
                            .autocapitalization(.words)
                            .focused($focusedField, equals: .name)

                        TextField("Amount (\(selectedCurrency))", text: $amount)
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .amount)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Done") {
                                        focusedField = nil
                                    }
                                }
                            }
                            .listRowSeparator(.hidden)
                    }

                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            HStack(spacing: 4) {
                                Label {
                                    Text(category.rawValue.capitalized)
                                        .foregroundStyle(.red)
                                } icon: {
                                    Image(systemName: category.iconName)
                                        .resizable()
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(category.color)
                                }
                            }
                        }
                    }

                    Toggle(isOn: $isExpense) {
                        Text(isExpense ? "Expense" : "Income")
                            .fontWeight(.semibold)
                            .foregroundColor(isExpense ? .red : .green)
                    }
                }
                Spacer()

                Button(action: saveExpense) {
                    Text("Save Expense")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(isSaveButtonEnabled ? Color.blue : Color.gray)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(!isSaveButtonEnabled)
                .padding(.bottom, 20)
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var isSaveButtonEnabled: Bool {
        !name.isEmpty && !amount.isEmpty && Double(amount) != nil && Double(amount)! > 0
    }

    private func saveExpense() {
        focusedField = nil
        guard let amountValue = Double(amount) else { return }
        let newTransaction = TransactionItem(
            name: name,
            category: selectedCategory,
            amount: amountValue,
            isExpense: isExpense,
            date: .now
        )
        viewModel.addExpense(transaction: newTransaction)
    }

    private enum Field: Hashable {
        case name
        case amount
    }
}

#Preview {
    AddExpenseView()
}
