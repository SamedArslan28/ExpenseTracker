import SwiftUI

struct AddExpenseView: View {
    @AppStorage("selectedCurrency") private var selectedCurrency: String = Locale.current.currencySymbol ?? "$"
    @State private var name: String = ""
    @State private var selectedCategory: TransactionCategory = .coffee
    @State private var amount: String = ""
    @State private var isExpense: Bool = false
    @State private var selectedDate: Date = .now
    @State private var isShowingSuccessAlert: Bool = false
    @FocusState private var isFocused: Bool

    let categories: [TransactionCategory] = TransactionCategory.allCases
    let viewModel: AddExpenseViewModel = .init(dataSource: .shared)

    var body: some View {
        VStack {
            Form {
                Section("Expense Details") {
                    TextField("Expense Name", text: $name)
                        .autocapitalization(.words)
                        .focused($isFocused)
                    TextField("Amount (\(selectedCurrency))", text: $amount)
                        .keyboardType(.decimalPad)
                        .focused($isFocused)
                }

                Section("Category") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            HStack(spacing: 4) {
                                Label {
                                    Text(category.rawValue.capitalized)
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

                Section(header: Text("Date")) {
                    DatePicker("Select Expense Date",
                               selection: $selectedDate,
                               in: ...Date(),
                               displayedComponents: .date)
                    .datePickerStyle(.graphical)
                }
            }
            Spacer()
            Button(action: saveExpense) {
                Text("Save Expense")
                    .padding()
                    .foregroundColor(.white)
                    .background(isSaveButtonEnabled ? Color.blue : Color.gray)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
            .disabled(!isSaveButtonEnabled)
        }
        .alert("Item saved successfully",
               isPresented: $isShowingSuccessAlert,
               actions: {})
        .navigationTitle("Add Expense")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Spacer()
                Button("Done") {
                    dismissKeyboard()
                }
            }
        }
    }


    private var isSaveButtonEnabled: Bool {
        !name.isEmpty && !amount.isEmpty && Double(amount) != nil && Double(amount)! > 0
    }

    private func saveExpense() {
        isFocused = false
        guard let amountValue = Double(amount) else { return }
        let newTransaction = TransactionItem(
            name: name,
            category: selectedCategory,
            amount: amountValue,
            isExpense: isExpense,
            date: .now
        )
        viewModel.addExpense(transaction: newTransaction)
        logger.info("New item added")
        isShowingSuccessAlert = true
    }
}

#Preview {
    AddExpenseView()
}

enum Field: Int, CaseIterable {
    case name
    case amount
}

extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
