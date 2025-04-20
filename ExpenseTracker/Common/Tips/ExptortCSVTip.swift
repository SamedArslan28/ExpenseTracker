//
//  DemoTip.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 28.03.2025.
//

import TipKit
import SwiftUI

struct ExportCSVTip: Tip {
    var title: Text {
        Text("Export Your Data")
    }

    var image: Image? {
        Image(systemName: "square.and.arrow.up")
    }

    var message: Text? {
        Text("You can export your transactions as a CSV file to use in other apps or keep for your records.")
    }
}
