// swiftlint:disable:this file_name
//  PlayAIMovesMiddleware.swift
//
//
//  Created by Hugues Telolahy on 14/07/2023.
//
// swiftlint:disable force_unwrapping

import Redux

extension Middlewares {
    static func playAIMoves(strategy: AIStrategy) -> Middleware<GameState> {
        { state, _ in
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
}

public protocol AIStrategy {
    func evaluateBestMove(_ actions: [GameAction], state: GameState) -> GameAction
}

public struct RandomStrategy: AIStrategy {
    public init() {}

    public func evaluateBestMove(_ actions: [GameAction], state: GameState) -> GameAction {
        actions.randomElement()!
    }
}

public struct AgressiveStrategy: AIStrategy {
    public init() {}

    public func evaluateBestMove(_ actions: [GameAction], state: GameState) -> GameAction {
        // swiftlint:disable no_magic_numbers
        let cardsValue: [String: Int] = [
            "bang": 3,
            "duel": 3,
            "gatling": 3,
            "endTurn": -1
        ]

        return actions.min { action1, action2 in
            let value1 = cardsValue[action1.playedCard] ?? 0
            let value2 = cardsValue[action2.playedCard] ?? 0
            return value1 > value2
        }!
    }
}

private extension GameAction {
    var playedCard: String {
        switch self {
        case .play(let card, _):
            card

        case .choose(let card, _):
            card

        default:
            fatalError("unexpected")
        }
    }
}
