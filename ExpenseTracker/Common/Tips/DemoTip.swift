//
//  DemoTip.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 28.03.2025.
//

import TipKit

struct DemoTip: Tip {
    var title: Text {
        Text("Tip demo")
    }

    var image: Image? {
        Image(systemName: "star.fill")
    }

    var message: Text? {
        Text("This is a demo tip. Falan filan dersin sonra bakarsin isine.")
    }
}
