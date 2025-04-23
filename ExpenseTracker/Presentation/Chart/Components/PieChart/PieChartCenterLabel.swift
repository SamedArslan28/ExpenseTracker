//
//  PieChartCenterLabel.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 4/23/25.
//

import SwiftUI

struct PieChartCenterLabel: View {
    let category: (category: TransactionCategory, total: Double)?
    let frame: CGRect

    var body: some View {
        VStack(spacing: 4) {
            if let category = category {
                Text(category.category.rawValue)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                Text("$\(category.total, specifier: "%.2f")")
                    .font(.title2.bold())
            }
        }
        .position(x: frame.midX, y: frame.midY)
    }
}
