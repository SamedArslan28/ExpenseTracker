//
//  CurrentBalanceView.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import SwiftUI

struct CurrentBalanceView: View {
    @State private var currentBalance: Int = 32_465
    @AppStorage("selectedCurrency") private var selectedCurrency: String = "USD"
    @State private var showAddTransactionSheet: Bool = false


    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showAddTransactionSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 38))
                            .foregroundStyle(.white)
                    }
                }
                Text("Current Balance")
                    .font(.title3)
                    .foregroundStyle(.thinMaterial)
                Text(currentBalance.formatted(.currency(code: selectedCurrency)).description)
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                Text(Date().formatted(.dateTime.year().month(.wide)))
                    .foregroundStyle(.white)
                HStack {
                    TransactionsDetailView(isIncome: true)
                    Spacer()
                    TransactionsDetailView(isIncome: false)
                }
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(
            MeshGradient (
                width: 3,
                height: 3,
                points: [
                    [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                    [0.0, 0.5], [0.9, 0.3], [1.0, 0.5],
                    [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]],
                colors: [
                    .green, .green, .green,
                    .blue, .blue ,.blue,
                    .black, .black, .black
                ]
            )
            .ignoresSafeArea()
        )
        .sheet(isPresented: $showAddTransactionSheet) {
            NavigationStack {
                AddTransactionView()
            }
        }
    }
}

#Preview {
    CurrentBalanceView()
}
