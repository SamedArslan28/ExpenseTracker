//
//  CategorySection.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.04.2025.
//

import SwiftUI

struct CategorySection: View {
    @Binding var viewModel: AddTransactionViewModel
    let categories = TransactionCategory.allCases
    var body: some View {
        Section(header: Text("Category")) {
            Picker("Category", selection: $viewModel.selectedCategory) {
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
            Picker("Type", selection: $viewModel.transactionType) {
                ForEach(TransactionType.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized)
                        .foregroundColor(type == .expense ? .red : .green)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}
