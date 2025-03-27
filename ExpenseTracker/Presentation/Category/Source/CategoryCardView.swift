//
//  CategoryCardView.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 28.03.2025.
//

import SwiftUI

struct CategoryCardView: View {
    let category: TransactionCategory
    var body: some View {
        VStack {
            Image(systemName: category.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
                .foregroundColor(category.color)
                .padding()

            Text(category.rawValue.capitalized)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.thickMaterial)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    CategoriesView()
}
