//
//  CSVDocument.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 28.03.2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct CSVDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.commaSeparatedText] }
    let csvData: Data

    init(transactions: [BaseTransaction]) {
        let csvString = CSVDocument.convertToCSV(transactions: transactions)
        self.csvData = Data(csvString.utf8)
    }

    init(configuration: ReadConfiguration) throws {
        self.csvData = configuration.file.regularFileContents ?? Data()
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: csvData)
    }

    static func convertToCSV(transactions: [BaseTransaction]) -> String {
        var csvString = "id,name,category,amount,isExpense,isFixed,date,day\n"
        for transaction in transactions {
            let id = transaction.id.uuidString
            let name = transaction.name
            let category = transaction.category.rawValue
            let amount = transaction.amount
            let isExpense = transaction.isExpense ? "true" : "false"
            let date = ISO8601DateFormatter().string(from: transaction.date)
            let row = "\(id),\(name),\(category),\(amount),\(isExpense),\(date)\n"
            csvString.append(row)
        }
        return csvString
    }
}
