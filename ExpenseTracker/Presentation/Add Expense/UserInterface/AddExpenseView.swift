import SwiftUI
import TipKit

struct AddTransactionView: View {
    @AppStorage("selectedCurrency") var selectedCurrency: String = Locale.current.currencySymbol ?? "$"
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var viewModel:AddTransactionViewModel = .init()
    @FocusState private var isInputActive: Bool

    var body: some View {
        NavigationView {
            Form {
                TransactionDetailsSection(viewModel: $viewModel,
                                          isInputActive: $isInputActive)
                CategorySection(viewModel: $viewModel)
                DatePickerSection(viewModel: $viewModel)
            }
            .navigationTitle("Add Transaction")
            .alert("Item saved successfully",
                   isPresented: $viewModel.isShowingSuccessAlert) {
                Button("OK") { dismiss() }
            }
            .toolbar {
                saveButton
                keyboardDismissButton
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
