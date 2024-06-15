// swiftlint:disable:this file_name
//
//  AppCore.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 15/06/2024.
//
import GameCore
import Redux
import SettingsCore

public enum App {
    public struct State: Codable, Equatable {
        public var screens: [Screen]
        public var settings: Settings.State
        public var game: GameState?

        public init(
            screens: [Screen],
            settings: Settings.State,
            game: GameState? = nil
        ) {
            self.screens = screens
            self.settings = settings
            self.game = game
        }
    }

    public enum Screen: Codable, Equatable {
        case splash
        case home
        case game
        case settings
    }

    public enum Action: Equatable {
        case navigate(Screen)
        case close
        case createGame
        case quitGame
        case settings(Settings.Action)
        case game(GameAction)
    }

    public static let reducer: Reducer<State, Action> = { state, action in
        var state = state

        switch action {
        case let .settings(settingsAction):
            state.settings = Settings.reducer(state.settings, settingsAction)

        case let .game(gameAction):
            state.game = state.game.flatMap { GameState.reducer($0, gameAction) }

        case let .navigate(screen):
            if case .splash = state.screens.last {
                state.screens = []
            }
            state.screens.append(screen)

        case .close:
            state.screens.removeLast()

        case .createGame:
            state.game = createGame(settings: state.settings)
            state.screens.append(.game)

        case .quitGame:
            state.game = nil
            state.screens.removeLast()
        }

        return state
    }
}

private extension App {
    static func createGame(settings: Settings.State) -> GameState {
        var game = Setup.createGame(
            playersCount: settings.playersCount,
            inventory: settings.inventory,
            preferredFigure: settings.preferredFigure
        )

        let manualPlayer: String? = settings.simulation ? nil : game.playOrder[0]
        game.playMode = game.startOrder.reduce(into: [:]) {
            $0[$1] = $1 == manualPlayer ? .manual : .auto
        }

        game.waitDelayMilliseconds = settings.waitDelayMilliseconds

        return game
    }
}
