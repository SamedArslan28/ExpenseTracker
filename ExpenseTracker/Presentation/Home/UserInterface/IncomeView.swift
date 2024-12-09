//
//  IncomeView.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import SwiftUI

struct IncomeView: View {
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "USD"
    @State var value: Int = 0
    var isIncome: Bool = false
    var body: some View {
        HStack(alignment: .top) {
            Image(isIncome ? "arrow.up.forward.circle.fill" : "arrow.down.left.circle.fill" )
            VStack(alignment: .leading) {
                Text(isIncome ? "Income" : "Expense")
                    .font(.title3)
                Text(value.formatted(.currency(code: selectedCurrency)).description)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}

#Preview {
    IncomeView()
}
