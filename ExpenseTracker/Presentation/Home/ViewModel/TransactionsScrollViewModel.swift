//
//  TransactionsScrollViewModel.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 9.12.2024.
//

import Foundation
import Observation

@Observable
final class TransactionsScrollViewModel {
    var balanceItems: [TransactionItem] = []

    private let dataSource: SwiftDataService

    init(dataSource: SwiftDataService) {
        self.dataSource = dataSource
        fetchItems()
    }

     func fetchItems() {
         balanceItems = dataSource.fetchExpenses().reversed()
    }
}
