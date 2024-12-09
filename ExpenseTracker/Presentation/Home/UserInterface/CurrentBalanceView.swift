//
//  CurrentBalanceView.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import SwiftUI

struct CurrentBalanceView: View {
    @State var currentBalance: Int = 32465
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "USD"
    var body: some View {
        VStack {
            Text("Current Balance")
                .font(.title3)
                .foregroundStyle(.thinMaterial)
            Text(currentBalance.formatted(.currency(code: selectedCurrency)).description)
                .font(.largeTitle)
                .foregroundStyle(.white)
            Text(Date().formatted(.dateTime.year().month(.wide)))
                .foregroundStyle(.white)
            HStack {
                IncomeView(isIncome: true)
                Spacer()
                IncomeView(isIncome: false)
            }
        }
        .padding(50)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.indigo]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

#Preview {
    CurrentBalanceView()
}
