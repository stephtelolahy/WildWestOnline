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
    static func playAIMoves() -> Middleware<GameState> {
        { state, _ in
            guard state.winner == nil else {
                return Empty().eraseToAnyPublisher()
            }

            if let active = state.active.first,
               case .auto(let strategy) = state.playMode[active.key] {
                let actions = active.value.map { GameAction.preparePlay($0, player: active.key) }
                let move = strategy.evaluateBestMove(actions, state: state)

                return Just(move)
                    .delay(for: .seconds(state.waitDelaySeconds), scheduler: RunLoop.main)
                    .eraseToAnyPublisher()
            }

            if let chooseOne = state.chooseOne.first,
               case .auto(let strategy) = state.playMode[chooseOne.key] {
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

private extension AIStrategy {
    func evaluateBestMove(_ actions: [GameAction], state: GameState) -> GameAction {
        evaluator.evaluateBestMove(actions, state: state)
    }

    protocol Evaluator {
        func evaluateBestMove(_ actions: [GameAction], state: GameState) -> GameAction
    }

    var evaluator: Evaluator {
        switch self {
        case .random: RandomStrategy()
        case .agressive: AgressiveStrategy()
        }
    }

    struct RandomStrategy: Evaluator {
        func evaluateBestMove(_ actions: [GameAction], state: GameState) -> GameAction {
            actions.randomElement()!
        }
    }

    struct AgressiveStrategy: Evaluator {
        func evaluateBestMove(_ actions: [GameAction], state: GameState) -> GameAction {
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
