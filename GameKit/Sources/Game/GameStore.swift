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
            // These are basic game rules
            // that won't be modellized as card effects
            // 1. Check if game is over
            // 2. Trigger card effects
            // 3. Resolve playing sequence
            // 4. Activate playable cards
            ComposedMiddleware([
                GameOverMiddleware(),
                CardEffectsMiddleware(),
                GameSequenceMiddleware(),
                ActivateCardsMiddleware()
            ]),
            LoggerMiddleware()
        ],
        completed: completed
    )
}
