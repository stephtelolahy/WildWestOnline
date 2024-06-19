//
//  UpdateGameMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 29/01/2024.
//
import Redux

/// Game loop features
public func updateGameMiddleware() -> any Middleware<GameState, GameAction> {
    ComposedMiddleware([
        CheckGameOverMiddleware(),
        TriggerCardEffectsMiddleware(),
        ProcessSequenceMiddleware(),
        ActivatePlayableCardsMiddleware(),
        PlayAIMovesMiddleware(strategy: RandomAIStrategy())
    ])
}
