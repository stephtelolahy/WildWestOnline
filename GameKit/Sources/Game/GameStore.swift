//
//  GameStore.swift
//  
//
//  Created by Hugues Telolahy on 09/04/2023.
//
import Redux

public func createGameStore(initial: GameState, completed: (() -> Void)? = nil) -> Store<GameState> {
    Store(
        initial: initial,
        reducer: GameState.reducer,
        middlewares: [
            ComposedMiddleware([
                CardEffectsMiddleware(),
                GameLoopMiddleware(),
                ActivateCardsMiddleware()
            ]),
            EventLoggerMiddleware()
        ],
        completed: completed
    )
}
