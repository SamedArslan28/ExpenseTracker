//
//  Appearance.swift
//  ExpenseTracker
//
//  Created by Abdulsamed Arslan on 25.01.2025.
//

import SwiftUI

enum Appearance: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { self.rawValue }

    var colorScheme: ColorScheme? {
        switch self {
            case .system: return nil
            case .light: return .light
            case .dark: return .dark
        }
    }
}
