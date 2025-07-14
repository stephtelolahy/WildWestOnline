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
    var backgroundColor: Color { get }
    var accentColor: Color { get }
}

public extension EnvironmentValues {
    @Entry var theme: AppTheme = DefaultTheme()
}

struct DefaultTheme: AppTheme {
    var backgroundColor = Color("BackgroundColor", bundle: .module)
    var accentColor =  Color("AccentColor", bundle: .module)
}
