//
//  GameStore.swift
//  
//
//  Created by Hugues Telolahy on 09/04/2023.
//
import Redux
import Game

func createGameStore(initial: GameState) -> Store<GameState> {
    Store(initial: initial,
          reducer: GameState.reducer,
          middlewares: [
            gameLoopMiddleware,
            activeCardMiddleware,
            eventLoggerMiddleware
          ])
}
