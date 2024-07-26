// swiftlint:disable:this file_name
//
//  AppTheme+EnvironementObject.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/03/2024.
//
import SwiftUI

public struct ThemeKey: EnvironmentKey {
    public static var defaultValue: AppTheme = DefaultTheme()
}

public extension EnvironmentValues {
    var theme: AppTheme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}
