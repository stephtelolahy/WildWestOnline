//
//  GameSetupCore.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//

import Redux
import GameCore
import SettingsCore
import NavigationCore

public enum GameSetupAction: Action {
    case startGame
    case quitGame
    case setGame(GameState)
    case unsetGame
}

func gameSetupReducer(
    state: inout AppState,
    action: Action,
    dependencies: Void
) throws -> Effect {
    guard let action = action as? GameSetupAction else {
        return .none
    }

    switch action {
    case .startGame:
        return .none

    case .setGame(let game):
        state.game = game

    case .quitGame:
        return .none

    case .unsetGame:
        state.game = nil
    }

    return .none
}

/*

 public extension Middlewares {
     static var setupGame: Middleware<AppState> {
         { state, action in
             guard let action = action as? GameSetupAction else {
                 return nil
             }

             return switch action {
             case .startGame:
                 GameSetupAction.setGame(
                         AppState.createGame(
                             settings: state.settings,
                             inventory: state.inventory
                         )
                     )

             case .setGame:
                 NavigationStackAction<MainDestination>.push(.game)

             case .quitGame:
                 GameSetupAction.unsetGame

             case .unsetGame:
                 NavigationStackAction<MainDestination>.pop
             }
         }
     }
 }

 private extension AppState {
     static func createGame(settings: SettingsState, inventory: Inventory) -> GameState {
         var game = Setup.buildGame(
             playersCount: settings.playersCount,
             inventory: inventory,
             preferredFigure: settings.preferredFigure
         )

         let manualPlayer: String? = settings.simulation ? nil : game.playOrder[0]
         game.playMode = game.playOrder.reduce(into: [:]) {
             $0[$1] = $1 == manualPlayer ? .manual : .auto
         }

         game.actionDelayMilliSeconds = settings.actionDelayMilliSeconds

         return game
     }
 }

 */
