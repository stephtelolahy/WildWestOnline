//
//  GameApp.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

import SwiftUI
import Redux
import Screen

private let store = Store<AppState, AppAction>(
    initial: AppState(screens: [.splash]),
    reducer: AppReducer().reduce,
    middlewares: [loggerMiddleware]
)

@main
struct GameApp: App {
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(store)
        }
    }
}
