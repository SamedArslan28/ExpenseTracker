//
//  BudgetSection.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 28.03.2025.
//

import SwiftUI

struct BudgetSection: View {


    var body: some View {
        Section(header: Text("Budget")) {
            NavigationLink("Add Fixed Income", destination: FixedIncomeView())
        }
    }
}
