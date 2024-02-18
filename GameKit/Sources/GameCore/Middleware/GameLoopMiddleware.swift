//
//  GameLoopMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 29/01/2024.
//
import Redux

/// Game engine features
/// 1. Check if game is over
/// 2. Trigger card effects
/// 3. Resolve playing sequence
/// 4. Activate playable cards
/// 5. Play AI moves
public func gameLoopMiddleware() -> Middleware<GameState> {
    ComposedMiddleware([
        GameOverMiddleware(),
        CardEffectsMiddleware(),
        PlaySequenceMiddleware(),
        ActivateCardsMiddleware(),
        AIAgentMiddleware(strategy: RandomAIStrategy())
    ])
}
