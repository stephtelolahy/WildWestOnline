//
//  AppState.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//
import GameCore
import NavigationCore
import Redux
import SettingsCore

/// Global app state
/// Organize State Structure Based on Data Types, Not Components
/// https://redux.js.org/style-guide/#organize-state-structure-based-on-data-types-not-components
public struct AppState: Codable, Equatable {
    public var navigation: NavigationState
    public var settings: SettingsState
    public let inventory: Inventory
    public var game: GameState?

    public init(
        navigation: NavigationState,
        settings: SettingsState,
        inventory: Inventory,
        game: GameState? = nil
    ) {
        self.navigation = navigation
        self.settings = settings
        self.inventory = inventory
        self.game = game
    }
}

public extension AppState {
    static let reducer: Reducer<Self, Any> = { state, action in
        var state = state
        switch action {
        case let action as RootNavigationAction:
            state.navigation.root = try RootNavigationState.reducer(state.navigation.root, action)

        case let action as GameSetupAction:
            state = try gameSetupReducer(state, action)

        case let action as SettingsAction:
            state.settings = try SettingsState.reducer(state.settings, action)

        case let action as GameAction:
            state.game = try state.game.flatMap { try GameState.reducer($0, action) }

        default:
            break
        }

        return state
    }
}

private extension AppState {
    static let gameSetupReducer: Reducer<Self, GameSetupAction> = { state, action in
        switch action {
        case .start:
            try startReducer(state, action)

        case .quit:
            try quitReducer(state, action)
        }
    }

    static let startReducer: Reducer<Self, GameSetupAction> = { state, action in
        guard case .start = action else {
            fatalError("unexpected")
        }

        var state = state
        state.game = createGame(settings: state.settings, inventory: state.inventory)
        // TODO: should emit navigation action through middleware
        state.navigation.root.path.append(.game)
        return state
    }

    static let quitReducer: Reducer<Self, GameSetupAction> = { state, action in
        guard case .quit = action else {
            fatalError("unexpected")
        }

        var state = state
        // TODO: should emit navigation action through middleware
        state.navigation.root.path.removeLast()
        state.game = nil
        return state
    }

    static func createGame(settings: SettingsState, inventory: Inventory) -> GameState {
        var game = Setup.buildGame(
            playersCount: settings.playersCount,
            inventory: inventory,
            preferredFigure: settings.preferredFigure
        )

        let manualPlayer: String? = settings.simulation ? nil : game.round.playOrder[0]
        game.config.playMode = game.round.startOrder.reduce(into: [:]) {
            $0[$1] = $1 == manualPlayer ? .manual : .auto
        }

        game.config.waitDelayMilliseconds = settings.waitDelayMilliseconds

        return game
    }
}
