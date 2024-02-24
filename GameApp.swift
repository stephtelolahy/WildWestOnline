//
//  GameApp.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
import App
import AppCore
import CardsRepository
import GameCore
import Redux
import SettingsCore
import SettingsRepository
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

private func createAppStore() -> Store<AppState> {
    let settingsService = SettingsRepository()
    let inventory = Inventory(
        figures: CardList.figures,
        cardSets: CardSets.bang,
        cardRef: CardList.all
    )

    let settings = SettingsState(
        playersCount: settingsService.playersCount,
        waitDelayMilliseconds: settingsService.waitDelayMilliseconds,
        simulation: settingsService.simulationEnabled,
        inventory: inventory
    )

    let initialState = AppState(
        screens: [.splash],
        settings: settings
    )

    return Store<AppState>(
        initial: initialState,
        reducer: AppState.reducer,
        middlewares: [
            gameLoopMiddleware()
                .lift { $0.game },
            SettingsMiddleware(service: settingsService)
                .lift { $0.settings },
            LoggerMiddleware()
        ]
    )
}
