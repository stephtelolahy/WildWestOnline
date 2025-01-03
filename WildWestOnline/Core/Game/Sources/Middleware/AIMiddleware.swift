//
//  AIMiddleware.swift
//
//  Created by Hugues Telolahy on 27/12/2024.
//
// swiftlint:disable force_unwrapping

import Redux

public extension Middlewares {
    static var playAIMove: Middleware<GameState> {
        { state, _ in
            if let pendingChoice = state.pendingChoice,
               state.playMode[pendingChoice.chooser] == .auto {
                let actions = pendingChoice.options.map { GameAction.choose($0.label, player: pendingChoice.chooser) }
                let strategy: AIStrategy = AgressiveStrategy()
                let bestMove = strategy.evaluateBestMove(actions, state: state)
                try? await Task.sleep(nanoseconds: UInt64(state.actionDelayMilliSeconds * 1_000_000))
                return bestMove
            }

            if state.active.isNotEmpty,
               let choice = state.active.first,
               state.playMode[choice.key] == .auto {
                let actions = choice.value.map { GameAction.play($0, player: choice.key) }
                let strategy: AIStrategy = AgressiveStrategy()
                let bestMove = strategy.evaluateBestMove(actions, state: state)
                try? await Task.sleep(nanoseconds: UInt64(state.actionDelayMilliSeconds * 1_000_000))
                return bestMove
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
        let itemValue: [String: Int] = [
            "bang": 3,
            "duel": 3,
            "gatling": 3,
            "panic": 1,
            "catBalou": 1,
            "endTurn": -1,
            "pass": -1
        ]

        return actions.shuffled().min { action1, action2 in
            let value1 = itemValue[action1.selectedItem] ?? 0
            let value2 = itemValue[action2.selectedItem] ?? 0
            return value1 > value2
        }!
    }
}

private extension GameAction {
    var selectedItem: String {
        guard let item = payload.card ?? payload.selection else {
            fatalError("Missing played card or choosen item")
        }

        return Card.extractName(from: item)
    }
}
