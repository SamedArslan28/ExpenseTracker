import SwiftUI
import SwiftData

struct AddFixedTransactionView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var isExpense: Bool = true
    @State private var category: TransactionCategory = .other
    @State private var recurrence: RecurrenceRule = .monthly
    @State private var startDate: Date = .now
    @State private var selectedDayOfWeek: Int = 1
    @State private var selectedDayOfMonth: Int = 1
    
    @AppStorage("selectedCurrency") private var selectedCurrency: String = Locale.current.currencySymbol ?? "$"

    var body: some View {
        NavigationStack {
            Form {
                detailsSection
                recurrenceSection
                recurrenceDetailsSection
            }
            .overlay(saveButton, alignment: .bottom)
            .toolbar { keyboardToolbar }
            .navigationTitle(isExpense ? "New Fixed Expense" : "New Fixed Income")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - View Components
private extension AddFixedTransactionView {
    
    var detailsSection: some View {
        Section(header: Text("Details").font(.headline)) {
            TextField("Name (e.g., Salary, Rent)", text: $name)
                .autocapitalization(.words)

            TextField("Amount (\(selectedCurrency))", text: $amount)
                .keyboardType(.decimalPad)
            
            Toggle(isExpense ? "Expense" : "Income", isOn: $isExpense)
            
            Picker("Category", selection: $category) {
                ForEach(TransactionCategory.allCases, id: \.self) { category in
                    Text(category.rawValue.capitalized).tag(category)
                }
            }
        }
    }

    var recurrenceSection: some View {
        Section(header: Text("Recurrence").font(.headline)) {
            Picker("Frequency", selection: $recurrence) {
                ForEach([RecurrenceRule.daily, .weekly, .monthly], id: \.self) { rule in
                    Text(rule.rawValue).tag(rule)
                }
            }
            .pickerStyle(.segmented)
            DatePicker("Start From", selection: $startDate, displayedComponents: .date)
        }
    }
    
    @ViewBuilder
    var recurrenceDetailsSection: some View {
        Section(header: Text("Frequency Details")) {
            switch recurrence {
            case .daily:
                dailyRecurrenceView
            case .weekly:
                weeklyRecurrenceView
            case .monthly:
                monthlyRecurrenceView
            case .yearly:
                yearlyRecurrenceView
            }
        }
    }

    var saveButton: some View {
        Button(action: saveTransaction) {
            Text(isExpense ? "Save Fixed Expense" : "Save Fixed Income")
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
            Button("Done") { dismissKeyboard() }
        }
    }
}

// MARK: - Recurrence Detail Views
private extension AddFixedTransactionView {
    
    var dailyRecurrenceView: some View {
        Text("This will repeat **every day** starting from the selected date.")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    
    var weeklyRecurrenceView: some View {
        Picker("Day of the Week", selection: $selectedDayOfWeek) {
            ForEach(1...7, id: \.self) { day in
                Text(weekdays[day - 1]).tag(day)
            }
        }
    }
    
    var monthlyRecurrenceView: some View {
        Picker("Day of the Month", selection: $selectedDayOfMonth) {
            ForEach(1...31, id: \.self) { day in
                Text("\(day)").tag(day)
            }
        }
        .pickerStyle(.wheel)
    }
    
    var yearlyRecurrenceView: some View {
        Text("Yearly recurrence can be added from the `FixedTransaction` model file.")
    }
}

// MARK: - Helpers
private extension AddFixedTransactionView {
    
    var isSaveButtonEnabled: Bool {
        !name.isEmpty && !amount.isEmpty && (Double(amount) ?? 0) > 0
    }
    
    var weekdays: [String] {
        var calendar = Calendar.current
        calendar.locale = Locale.current
        return calendar.weekdaySymbols
    }
}

// MARK: - Actions
private extension AddFixedTransactionView {
    
    func saveTransaction() {
        guard let amountValue = Double(amount) else { return }
        
        let firstDueDate = calculateFirstDueDate()
        
        let newTransaction = FixedTransaction(
            name: name,
            amount: amountValue,
            isExpense: isExpense,
            category: category,
            recurrence: recurrence,
            startDate: firstDueDate
        )
        
        modelContext.insert(newTransaction)
        dismiss()
    }
    
    func calculateFirstDueDate() -> Date {
        let calendar = Calendar.current
        let effectiveStartDate = calendar.startOfDay(for: startDate)
        
        switch recurrence {
        case .daily:
            return effectiveStartDate
            
        case .weekly:
            var dateComponents = DateComponents()
            dateComponents.weekday = selectedDayOfWeek
            
            return calendar.nextDate(
                after: calendar.date(byAdding: .day, value: -1, to: effectiveStartDate)!,
                matching: dateComponents,
                matchingPolicy: .nextTime
            ) ?? effectiveStartDate
            
        case .monthly:
            var dateComponents = calendar.dateComponents([.year, .month], from: effectiveStartDate)
            dateComponents.day = selectedDayOfMonth
            
            var firstDate = calendar.date(from: dateComponents)!
            
            if firstDate < effectiveStartDate {
                firstDate = calendar.date(byAdding: .month, value: 1, to: firstDate)!
            }
            return firstDate
            
        case .yearly:
            return effectiveStartDate
        }
    }
}

// MARK: - Preview
#Preview {
    AddFixedTransactionView()
        .modelContainer(for: [FixedTransaction.self], inMemory: true)
}

// MARK: - View Extension
extension View {
    func dismissKeyboard() {
        UIApplication
            .shared
            .sendAction(#selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil)
    }
}
