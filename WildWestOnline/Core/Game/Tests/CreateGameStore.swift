//
//  CreateGameStore.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/01/2025.
//
import Redux
import GameCore

@MainActor func createGameStore(initialState: GameState) -> Store<GameState, Void> {
    .init(
        initialState: initialState,
        reducer: gameReducer,
        dependencies: ()
    )
}
