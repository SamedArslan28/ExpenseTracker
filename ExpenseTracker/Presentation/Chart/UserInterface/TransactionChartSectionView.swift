//
//  TransactionChartSectionView.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.04.2025.
//

import SwiftUI
import Charts

struct TransactionChartSectionView: View {
    let title: String
    let items: [any BaseTransaction]

    var body: some View {
        VStack(spacing: 16) {
            MonthlyExpense()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.thickMaterial)
        )
        .frame(height: 380)
        .padding(.horizontal)
    }
}


