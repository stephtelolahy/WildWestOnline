// swiftlint:disable:this file_name
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
    var backgroundView = Color.init(red: 249.0/255.0, green: 215.0/255.0, blue: 160.0/255.0)

    var buttoColor = Color(
        red: 148.0 / 255.0,
        green: 82.0 / 255.0,
        blue: 0.0 / 255.0
    )
}
