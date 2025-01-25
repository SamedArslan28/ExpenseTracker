//
//  TextFieldStyles.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 24.01.2025.
//

import SwiftUI

// MARK: - ROUNDED STYLE

struct RoundedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical)
            .padding(.horizontal, 24)
            .background(
                Color(UIColor.systemGray6)
            )
            .clipShape(Capsule(style: .continuous))
    }
}
