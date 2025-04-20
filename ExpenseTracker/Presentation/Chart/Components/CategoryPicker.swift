//
//  CategoryPicker.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 4/18/25.
//

import SwiftUI

struct CategoryPicker: View {
    @Binding var selectedCategory: TransactionCategory

    private let categories = TransactionCategory.allCases.filter { $0 != .fixedExpenses }

    var body: some View {
        HStack {
            Text("Select a Category")
                .font(.headline)
            Spacer()
            Picker("Category", selection: $selectedCategory.animation(.easeInOut)) {
                ForEach(categories, id: \.self) { category in
                    Label {
                        Text(category.rawValue.capitalized)
                    } icon: {
                        Image(systemName: category.iconName)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(category.color)
                    }
                }
            }
            .pickerStyle(.menu)
        }
    }
}





