//
//  Theme.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//

import SwiftUI

/// App theme
///
final class Theme: ObservableObject {
    @Published var backgroundColor = Color(
        red: 208.0 / 255.0,
        green: 180.0 / 255.0,
        blue: 140.0 / 255.0
    ).gradient

    @Published var buttonColor = Color(
        red: 148.0 / 255.0,
        green: 82.0 / 255.0,
        blue: 0.0 / 255.0
    )
}
