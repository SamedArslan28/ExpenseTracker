//
//  CustomLabelStyle.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 24.01.2025.
//

import SwiftUI

// MARK: - CUSTOM DEMO STYLE

struct CustomLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .title
            .foregroundStyle(.orange)
    }
}
