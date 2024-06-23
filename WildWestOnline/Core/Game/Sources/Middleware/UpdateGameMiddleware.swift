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
        chain([
            checkGameOver(),
            triggerCardEffects(),
            processSequence(),
            activatePlayableCards(),
            playAIMoves(strategy: AgressiveStrategy())
        ])
    }
}
