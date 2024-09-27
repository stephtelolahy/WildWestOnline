//  PlayAIMovesMiddleware.swift
//
//
//  Created by Hugues Telolahy on 14/07/2023.
//
// swiftlint:disable force_unwrapping

import Combine
import Redux
import Foundation

extension Middlewares {
    static func playAIMoves(strategy: AIStrategy) -> Middleware<GameState> {
        { state, _ in
            guard state.winner == nil else {
                return Empty().eraseToAnyPublisher()
            }

            if let active = state.active.first,
               state.playMode[active.key] == .auto {
                let actions = active.value.map { GameAction.preparePlay($0, player: active.key) }
                let move = strategy.evaluateBestMove(actions, state: state)

                return Just(move)
                    .delay(for: .seconds(state.waitDelaySeconds), scheduler: RunLoop.main)
                    .eraseToAnyPublisher()
            }

            if let chooseOne = state.chooseOne.first,
               state.playMode[chooseOne.key] == .auto {
                let actions = chooseOne.value.options.map { GameAction.prepareChoose($0, player: chooseOne.key) }
                let move = strategy.evaluateBestMove(actions, state: state)

                return Just(move)
                    .delay(for: .seconds(state.waitDelaySeconds), scheduler: RunLoop.main)
                    .eraseToAnyPublisher()
            }

            return Empty().eraseToAnyPublisher()
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
        let cardsValue: [String: Int] = [
            "bang": 3,
            "duel": 3,
            "gatling": 3,
            "endTurn": -1
        ]

        return actions.shuffled().min { action1, action2 in
            let value1 = cardsValue[action1.playedCard] ?? 0
            let value2 = cardsValue[action2.playedCard] ?? 0
            return value1 > value2
        }!
    }
}

private extension GameAction {
    var playedCard: String {
        switch self {
        case .preparePlay(let card, _):
            card

        case .prepareChoose(let card, _):
            card

        default:
            fatalError("unexpected")
        }
    }
}
