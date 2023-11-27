//
//  GameApp.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

import SwiftUI
import Redux
import Screen

private let store = Store<AppState>(
    initial: .init(),
    reducer: AppState.reducer,
    middlewares: [
        LoggerMiddleware()
    ]
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
