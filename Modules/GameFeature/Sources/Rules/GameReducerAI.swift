//
//  GameReducerAI.swift
//
//  Created by Hugues Telolahy on 27/12/2024.
//
import Redux

extension GameFeature {
    static func reducerAI(
        into state: inout State,
        action: Action,
        dependencies: Void
    ) -> Effect<Action> {
        let state = state
        return .run {
            await playAIMove(state: state, action: action)
        }
    }

    private static func playAIMove(state: State, action: Action) async -> Action? {
        if let pendingChoice = state.pendingChoice,
           state.playMode[pendingChoice.chooser] == .auto {
            let actions = pendingChoice.options.map { GameFeature.Action.choose($0.label, player: pendingChoice.chooser) }
            let strategy: AIStrategy = AgressiveStrategy()
            let bestMove = strategy.evaluateBestMove(actions, state: state)
            try? await Task.sleep(nanoseconds: UInt64(state.actionDelayMilliSeconds * 1_000_000))
            return bestMove
        }

        if state.active.isNotEmpty,
           let choice = state.active.first,
           state.playMode[choice.key] == .auto {
            let actions = choice.value.map { GameFeature.Action.preparePlay($0, player: choice.key) }
            let strategy: AIStrategy = AgressiveStrategy()
            let bestMove = strategy.evaluateBestMove(actions, state: state)
            try? await Task.sleep(nanoseconds: UInt64(state.actionDelayMilliSeconds * 1_000_000))
            return bestMove
        }

        return nil
    }
}
