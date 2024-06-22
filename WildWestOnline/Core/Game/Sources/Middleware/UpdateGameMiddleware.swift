// swiftlint:disable:this file_name
//
//  UpdateGameMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 29/01/2024.
//
import Redux

/// Game loop features
public extension Middlewares {
    static func updateGame() -> Middleware<GameState> {
        Middlewares.compose([
            Middlewares.checkGameOver(),
            Middlewares.triggerCardEffects(),
            Middlewares.processSequence(),
            Middlewares.activatePlayableCards(),
            Middlewares.playAIMoves(strategy: RandomAIStrategy())
        ])
    }
}
