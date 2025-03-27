//
//  BudgetSection.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 28.03.2025.
//

import SwiftUI

struct BudgetSection: View {
    @Binding var budget: Double

    var body: some View {
        Section(header: Text("Budget")) {
            VStack(alignment: .leading) {
                Text("Set Monthly Budget: $\(Int(budget))")
                Slider(value: $budget, in: 100...5_000, step: 50)
            }
            NavigationLink("Add Fixed Income", destination: FixedIncomeView())
        }
    }
}
