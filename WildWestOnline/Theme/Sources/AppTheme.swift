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
    var colorBackground: Color { get }
    var colorAccent: Color { get }
    var fontHeadline: Font { get }
    var fontTitle: Font { get }
}

public extension EnvironmentValues {
    @Entry var theme: AppTheme = DefaultTheme()
}

struct DefaultTheme: AppTheme {
    private static let fontName = "AmericanTypewriter-Bold"

    var colorBackground = Color("BackgroundColor", bundle: .module)
    var colorAccent = Color("AccentColor", bundle: .module)
    var fontHeadline = Font.custom(fontName, size: 12, relativeTo: .headline)
    var fontTitle = Font.custom(fontName, size: 16, relativeTo: .title)
}
