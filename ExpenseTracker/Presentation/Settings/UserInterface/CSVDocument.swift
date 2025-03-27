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

    init(transactions: [TransactionItem]) {
        let csvString = TransactionItem.convertToCSV(transactions: transactions)
        self.csvData = Data(csvString.utf8)
    }

    init(configuration: ReadConfiguration) throws {
        self.csvData = configuration.file.regularFileContents ?? Data()
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: csvData)
    }
}
