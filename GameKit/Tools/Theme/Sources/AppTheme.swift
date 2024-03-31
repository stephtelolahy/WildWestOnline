//
//  AppTheme.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//
// swiftlint:disable no_magic_numbers

import SwiftUI

/// App theme
///
public protocol AppTheme {
    var backgroundView: Color { get }
    var buttoColor: Color { get }
}

struct DefaultTheme: AppTheme {
    var backgroundView = Color.orange.opacity(0.4)

    var buttoColor = Color(
        red: 148.0 / 255.0,
        green: 82.0 / 255.0,
        blue: 0.0 / 255.0
    )
}
