//  PlayAIMovesMiddleware.swift
//
//
//  Created by Hugues Telolahy on 14/07/2023.
//

import Redux

public final class PlayAIMovesMiddleware: MiddlewareV1<GameState> {
    private let strategy: AIStrategy

    public init(strategy: AIStrategy) {
        self.strategy = strategy
    }

    override public func effect(on action: ActionV1, state: GameState) async -> ActionV1? {
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

public protocol AIStrategy {
    func evaluateBestMove(_ actions: [GameAction], state: GameState) -> GameAction
}

public struct RandomAIStrategy: AIStrategy {
    public init() {}

    public func evaluateBestMove(_ actions: [GameAction], state: GameState) -> GameAction {
        // swiftlint:disable force_unwrapping
        actions.randomElement()!
    }
}
