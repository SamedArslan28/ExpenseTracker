//
//  CategoryDetailView.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 25.01.2025.
//

import SwiftUI

struct CategoryDetailView: View {
    let category: TransactionCategory
//    let totals: (expenses: Double, incomes: Double)

    var body: some View {
        VStack(spacing: 20) {
            Text(category.rawValue.capitalized)
                .font(.largeTitle)
                .foregroundColor(category.color)

            HStack {
                Text("Total Expenses:")
                Spacer()
//                Text("\(totals.expenses, specifier: "%.2f")")
                    .foregroundColor(.red)
            }
            .padding()

            HStack {
                Text("Total Incomes:")
                Spacer()
//                Text("\(totals.incomes, specifier: "%.2f")")
                    .foregroundColor(.green)
            }
            .padding()
            Spacer()
        }
        .padding()
        .navigationTitle(category.rawValue.capitalized)
    }
}
