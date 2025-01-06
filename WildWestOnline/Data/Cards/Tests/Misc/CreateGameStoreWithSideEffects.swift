//
//  CreateGameStoreWithSideEffects.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2025.
//

import Redux
import GameCore

@MainActor func createGameStoreWithSideEffects(initialState: GameState) -> Store<GameState, Void> {
    .init(
        initialState: initialState,
        reducer: gameReducer,
        dependencies: ()
    )
}
