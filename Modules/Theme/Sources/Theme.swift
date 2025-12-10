//
//  Theme.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//
import SwiftUI

public protocol Theme {
    var colorBackground: Color { get }
    var colorAccent: Color { get }
    var fontHeadline: Font { get }
    var fontTitle: Font { get }
}

public extension EnvironmentValues {
    @Entry var theme: Theme = DefaultTheme()
}

struct DefaultTheme: Theme {
    private static let fontName = "AmericanTypewriter-Bold"

    var colorBackground = Color("BackgroundColor", bundle: .module)
    var colorAccent = Color("AccentColor", bundle: .module)
    var fontHeadline = Font.custom(fontName, size: 12, relativeTo: .headline)
    var fontTitle = Font.custom(fontName, size: 16, relativeTo: .title)
}
