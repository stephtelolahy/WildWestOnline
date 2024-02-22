//
//  GameApp.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
import App
import SwiftUI
import Theme

@main
struct GameApp: App {
    var body: some Scene {
        WindowGroup {
            AppView {
                createAppStore()
            }
            .environment(\.colorScheme, .light)
            .accentColor(AppColor.button)
        }
    }
}
