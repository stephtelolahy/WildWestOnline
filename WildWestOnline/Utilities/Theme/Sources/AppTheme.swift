//
//  AppTheme.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//
import SwiftUI

/// App theme
///
public protocol AppTheme {
    var backgroundView: Color { get }
    var accentColor: Color { get }
}

public extension EnvironmentValues {
    @Entry var theme: AppTheme = DefaultTheme()
}
