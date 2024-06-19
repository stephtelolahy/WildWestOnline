//  PlayAIMovesMiddleware.swift
//
//
//  Created by Hugues Telolahy on 14/07/2023.
//

import Redux

struct PlayAIMovesMiddleware: Middleware {
    let strategy: AIStrategy

    func handle(_ action: GameAction, state: GameState) async -> GameAction? {
        guard state.winner == nil else {
            return nil
        }

        if let active = state.active.first,
           state.playMode[active.key] == .auto {
            let actions = active.value.map { GameAction.play($0, player: active.key) }
            return strategy.evaluateBestMove(actions, state: state)
        }

        if let chooseOne = state.chooseOne.first,
           state.playMode[chooseOne.key] == .auto {
            let actions = chooseOne.value.options.map { GameAction.choose($0, player: chooseOne.key) }
            return strategy.evaluateBestMove(actions, state: state)
        }

        return nil
    }
}

protocol AIStrategy {
    func evaluateBestMove(_ actions: [GameAction], state: GameState) -> GameAction
}

struct RandomAIStrategy: AIStrategy {
    func evaluateBestMove(_ actions: [GameAction], state: GameState) -> GameAction {
        // swiftlint:disable force_unwrapping
        actions.randomElement()!
    }
}
