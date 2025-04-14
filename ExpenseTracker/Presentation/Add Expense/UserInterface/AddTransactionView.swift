import SwiftUI
import TipKit

struct AddTransactionView: View {
    @AppStorage("selectedCurrency") var selectedCurrency: String = Locale.current.currencySymbol ?? "$"
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: AddTransactionViewModel = .init()
    @FocusState private var isInputActive: Bool

    var body: some View {
        Form {
            TransactionDetailsSection(viewModel: $viewModel,
                                      isInputActive: $isInputActive)

            CategorySection(viewModel: $viewModel)
            DatePickerSection(viewModel: $viewModel)
        }
        .scrollDismissesKeyboard(.immediately)
        .navigationTitle("Add Transaction")
        .toolbar {
            saveButton
            keyboardDismissButton
        }
        .alert("Item saved successfully",
               isPresented: $viewModel.isShowingSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        }
    }

    private var saveButton: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button("Save") {
                saveTransaction()
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

    private var amountFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = Locale.current.groupingSeparator
        formatter.decimalSeparator = Locale.current.decimalSeparator
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter
    }

    private func saveTransaction() {
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

