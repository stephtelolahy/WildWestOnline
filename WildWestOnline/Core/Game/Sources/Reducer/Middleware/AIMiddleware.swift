//
//  AIMiddleware.swift
//
//  Created by Hugues Telolahy on 27/12/2024.
//
// swiftlint:disable force_unwrapping
/*
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
*/
