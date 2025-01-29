import SwiftUI

struct AddFixedIncomeView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var viewModel: FixedIncomeViewModel

    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var selectedDay: Int = 1

    @AppStorage("selectedCurrency") private var selectedCurrency: String = Locale.current.currencySymbol ?? "$"
    @FocusState private var focusedField: Field?

    private var isSaveButtonEnabled: Bool {
        !name.isEmpty && !amount.isEmpty && (Double(amount) ?? 0) > 0
    }

    var body: some View {
        Form {
            expenseDetailsSection
            datePickerSection
        }
        .overlay(saveButton, alignment: .bottom)
        .toolbar { keyboardToolbar }
    }
}

// MARK: - Components
private extension AddFixedIncomeView {
    var expenseDetailsSection: some View {
        Section(header: Text("Expense Details").font(.headline)) {
            TextField("Expense Name", text: $name)
                .autocapitalization(.words)
                .focused($focusedField, equals: .name)

            TextField("Amount (\(selectedCurrency))", text: $amount)
                .keyboardType(.decimalPad)
                .focused($focusedField, equals: .amount)
        }
    }

    var datePickerSection: some View {
        Section(header: Text("Date")) {
            Picker("Day", selection: $selectedDay) {
                ForEach(1...31, id: \.self) { day in
                    Text("\(day)").tag(day)
                }
            }
        }
    }

    var saveButton: some View {
        Button(action: saveExpense) {
            Text("Save Expense")
                .frame(maxWidth: .infinity)
                .padding()
                .background(isSaveButtonEnabled ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
        }
        .disabled(!isSaveButtonEnabled)
        .padding(.bottom, 20)
    }

    var keyboardToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button("Done") { focusedField = nil }
        }
    }
}

// MARK: - Actions

private extension AddFixedIncomeView {
    func saveExpense() {
        guard let amountValue = Double(amount) else { return }
        let newTransaction = TransactionItem(
            name: name,
            category: .other,
            amount: amountValue,
            isExpense: false,
            isFixed: true,
            date: .now,
            day: selectedDay
        )
        viewModel.addFixedItem(newTransaction)
        logger.info("New fixed income added: \(name), Amount: \(amountValue), Day: \(selectedDay)")
        dismiss()
    }
}
