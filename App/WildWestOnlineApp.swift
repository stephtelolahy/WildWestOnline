//
//  WildWestOnlineApp.swift
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
struct WildWestOnlineApp: App {
    @Environment(\.theme) private var theme

    var body: some Scene {
        WindowGroup {
            AppView {
                createStore()
            }
            .environment(\.colorScheme, .light)
            .accentColor(theme.accentColor)
        }
    }
}

private func createStore() -> Store<AppState, AppAction> {
    let settingsService = SettingsRepository()
    let cardsService = CardsRepository()

    let settings = SettingsState.makeBuilder()
        .withInventory(cardsService.inventory)
        .withPlayersCount(settingsService.playersCount)
        .withWaitDelayMilliseconds(settingsService.waitDelayMilliseconds)
        .withSimulation(settingsService.simulationEnabled)
        .withPreferredFigure(settingsService.preferredFigure)
        .build()

    let initialState = AppState(
        screens: [.splash],
        settings: settings
    )

    return Store(
        initial: initialState,
        reducer: AppState.reducer,
        middlewares: [
            updateGameMiddleware()
                .lift(
                    deriveState: { $0.game },
                    deriveAction: { $0.toGame() },
                    embedAction: { .game($0) }
                ),
            SaveSettingsMiddleware(service: settingsService)
                .lift(
                    deriveState: { $0.settings },
                    deriveAction: { $0.toSettings() },
                    embedAction: { .settings($0) }
                ),
            LoggerMiddleware()
        ]
    )
}

private extension AppAction {
    func toGame() -> GameAction? {
        guard case let .game(gameAction) = self else {
            return nil
        }
        return gameAction
    }

    func toSettings() -> SettingsAction? {
        guard case let .settings(settingsAction) = self else {
            return nil
        }
        return settingsAction
    }
}
