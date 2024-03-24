//
//  AppColor.swift
//  
//
//  Created by Hugues Telolahy on 08/12/2023.
//
// swiftlint:disable no_magic_numbers

import SwiftUI

@available(*, deprecated, message: "Use `@EnvironmentObject var theme: Theme` instead")
public enum AppColor {
    public static var background = Color(
        red: 208.0 / 255.0,
        green: 180.0 / 255.0,
        blue: 140.0 / 255.0
    ).gradient

    public static var button = Color(
        red: 148.0 / 255.0,
        green: 82.0 / 255.0,
        blue: 0.0 / 255.0
    )
}

@available(*, deprecated, message: "Use `@EnvironmentObject var theme: Theme` instead")
public enum AppTheme {
    public static var backgroundView = Color.orange.opacity(0.4)
}
