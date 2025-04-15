import SwiftUI

struct AddTransactionView: View {
    @AppStorage("selectedCurrency") var selectedCurrency: String = Locale.current.currencySymbol ?? "$"
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @FocusState private var isInputActive: Bool

    @State private var viewModel: AddTransactionViewModel = .init()
    @State private var showErrorMessage: Bool = false

    var body: some View {
        Form {
            TransactionDetailsSection(viewModel: $viewModel,
                                      isInputActive: $isInputActive)

            CategorySection(viewModel: $viewModel)
            DatePickerSection(viewModel: $viewModel)
        }
        .toolbar {
            saveButton
            keyboardDismissButton
        }
        .alert("Error", isPresented: $showErrorMessage) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("There was an error saving the transaction.")
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

    private func saveTransaction() {
        guard let transaction = viewModel.createTransaction() else { return }
        modelContext.insert(transaction)
        do {
            try modelContext.save()
            dismiss()
            viewModel.reset()
        } catch  {
            showErrorMessage = true
        }
    }
}

