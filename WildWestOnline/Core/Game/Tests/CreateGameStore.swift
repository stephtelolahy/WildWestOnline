//
//  CreateGameStore.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//
import Redux
import GameCore

typealias GameStore = Store<GameState, GameAction, Void>

@MainActor func createGameStore(initialState: GameState) -> GameStore {
    .init(
        initialState: initialState,
        reducer: gameReducer,
        dependencies: ()
    )
}
