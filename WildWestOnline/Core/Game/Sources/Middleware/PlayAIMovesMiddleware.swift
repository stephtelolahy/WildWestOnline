//  PlayAIMovesMiddleware.swift
//
//
//  Created by Hugues Telolahy on 14/07/2023.
//
// swiftlint:disable force_unwrapping

import Redux

extension Middlewares {
    static func playAIMoves(strategy: AIStrategy) -> Middleware<GameState, GameAction> {
        { state, _ in
            guard state.sequence.winner == nil else {
                return nil
            }

            if let active = state.sequence.active.first,
               state.config.playMode[active.key] == .auto {
                let actions = active.value.map { GameAction.preparePlay($0, player: active.key) }
                let move = strategy.evaluateBestMove(actions, state: state)

                let milliToNanoSeconds = 1_000_000
                let waitDelay = state.config.waitDelayMilliseconds
                try? await Task.sleep(nanoseconds: UInt64(waitDelay * milliToNanoSeconds))

                return move
            }

            if let chooseOne = state.sequence.chooseOne.first,
               state.config.playMode[chooseOne.key] == .auto {
                let actions = chooseOne.value.options.map { GameAction.prepareChoose($0, player: chooseOne.key) }
                let move = strategy.evaluateBestMove(actions, state: state)

                let milliToNanoSeconds = 1_000_000
                let waitDelay = state.config.waitDelayMilliseconds
                try? await Task.sleep(nanoseconds: UInt64(waitDelay * milliToNanoSeconds))

                return move
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
