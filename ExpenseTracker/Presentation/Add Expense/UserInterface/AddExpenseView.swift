import SwiftUI
import TipKit

struct AddExpenseView: View {
    @AppStorage("selectedCurrency") var selectedCurrency: String = Locale.current.currencySymbol ?? "$"
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var viewModel:AddExpenseViewModel = .init()
    @FocusState private var isInputActive: Bool

    var body: some View {
        NavigationStack {
            Form {
                ExpenseDetailsSection(viewModel: $viewModel,
                                      isInputActive: $isInputActive)
                CategorySection(viewModel: $viewModel)
                DatePickerSection(viewModel: $viewModel)
            }
            .navigationTitle("Add Expense")
            .toolbar {
                saveButton
                keyboardDismissButton
            }
            .alert("Item saved successfully",
                   isPresented: $viewModel.isShowingSuccessAlert) {
                Button("OK") { dismiss() }
            }
        }
    }

    private var saveButton: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("Save") {
                saveExpense()
            }
            .disabled(!viewModel.isSaveButtonEnabled)
        }
    }

    private var keyboardDismissButton: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button {
                isInputActive = false
            } label: {
                Image(systemName: "keyboard.chevron.compact.down")
            }
        }
    }

    private func saveExpense() {
        guard let transaction = viewModel.createTransaction() else { return }
        modelContext.insert(transaction)
        do {
            try modelContext.save()
            viewModel.isShowingSuccessAlert = true
            viewModel.reset()
        } catch  {
            print(error)
        }
    }
}
