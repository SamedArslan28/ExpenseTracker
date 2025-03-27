import SwiftUI
import TipKit

struct AddExpenseView: View {
    @AppStorage("selectedCurrency") private var selectedCurrency: String = Locale.current.currencySymbol ?? "$"
    @State private var name: String = ""
    @State private var selectedCategory: TransactionCategory = .coffee
    @State private var amount: String = ""
    @State private var transactionType: TransactionType = .expense
    @State private var selectedDate: Date = .now
    @State private var isShowingSuccessAlert: Bool = false
    @FocusState private var isInputActive: Bool
    @Environment(\.dismiss) private var dismiss

    private let categories: [TransactionCategory] = TransactionCategory.allCases
    private let viewModel: AddExpenseViewModel = .init(dataSource: .shared)

    var body: some View {

        Form {
            ExpenseDetailsSection(
                name: $name,
                amount: $amount,
                selectedCurrency: selectedCurrency,
                isInputActive: $isInputActive
            )

            CategorySection(
                selectedCategory: $selectedCategory,
                transactionType: $transactionType
            )

            DatePickerSection(
                selectedDate: $selectedDate
            )
        }
        .navigationTitle("Add Expense")
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") { isInputActive = false }
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            ToolbarItem(placement: .primaryAction) {
                Button("Save") {
                    saveExpense()
                }
                .disabled(!isSaveButtonEnabled)
                // TODO: - Fix this tip
                .popoverTip(DemoTip())
            }
        }
        .alert("Item saved successfully",
               isPresented: $isShowingSuccessAlert) {
            Button("OK") { dismiss() }
        }

    }

    private var isSaveButtonEnabled: Bool {
        guard let amountValue = Double(amount), amountValue > 0 else { return false }
        return !name.isEmpty
    }

    private func saveExpense() {
        isInputActive = false
        guard let amountValue = Double(amount) else { return }

        let newTransaction = TransactionItem(
            name: name,
            category: selectedCategory,
            amount: amountValue,
            isExpense: transactionType == .expense,
            date: selectedDate
        )

        viewModel.addExpense(transaction: newTransaction)
        isShowingSuccessAlert = true
        resetForm()
    }

    private func resetForm() {
        name = ""
        amount = ""
        transactionType = .expense
        selectedCategory = .coffee
        selectedDate = .now
    }
}

#Preview {
    NavigationView {
        AddExpenseView()
    }
}

// MARK: - Subviews

private struct ExpenseDetailsSection: View {
    @Binding var name: String
    @Binding var amount: String
    let selectedCurrency: String
    @FocusState.Binding var isInputActive: Bool

    var body: some View {
        Section(header: Text("Expense Details")) {
            TextField("Expense Name",
                      text: $name)
            .autocapitalization(.words)
            .focused($isInputActive)

            TextField("Amount (\(selectedCurrency))",
                      text: $amount)
            .keyboardType(.decimalPad)
            .focused($isInputActive)
        }
    }
}

private struct CategorySection: View {
    @Binding var selectedCategory: TransactionCategory
    @Binding var transactionType: TransactionType
    let categories = TransactionCategory.allCases

    var body: some View {
        Section(header: Text("Category")) {
            Picker("Category", selection: $selectedCategory) {
                ForEach(categories, id: \.self) { category in
                    HStack {
                        Image(systemName: category.iconName)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(category.color)
                        Text(category.rawValue.capitalized)
                    }
                }
            }
            .pickerStyle(.menu)

            Picker("Type", selection: $transactionType) {
                ForEach(TransactionType.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized)
                        .foregroundColor(type == .expense ? .red : .green)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

private struct DatePickerSection: View {
    @Binding var selectedDate: Date

    var body: some View {
        Section(header: Text("Date")) {
            DatePicker("Select Expense Date", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(.graphical)
        }
    }
}

// MARK: - Enums

enum TransactionType: String, CaseIterable {
    case expense = "Expense"
    case income = "Income"
}
