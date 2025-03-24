//
//  PlayAIMoveReducer.swift
//
//  Created by Hugues Telolahy on 27/12/2024.
//
import Redux

public func playAIMoveReducer(
    state: inout GameState,
    action: Action,
    dependencies: Void
) throws -> Effect {
    let state = state
    return .run {
        await playAIMove(state: state, action: action)
    }
}

private func playAIMove(state: GameState, action: Action) async -> Action? {
    if let pendingChoice = state.pendingChoice,
       state.playMode[pendingChoice.chooser] == .auto {
        let actions = pendingChoice.options.map { GameAction.choose($0.label, actor: pendingChoice.chooser) }
        let strategy: AIStrategy = AgressiveStrategy()
        let bestMove = strategy.evaluateBestMove(actions, state: state)
        try? await Task.sleep(nanoseconds: UInt64(state.actionDelayMilliSeconds * 1_000_000))
        return bestMove
    }

    if state.active.isNotEmpty,
       let choice = state.active.first,
       state.playMode[choice.key] == .auto {
        let actions = choice.value.map { GameAction.preparePlay($0, player: choice.key) }
        let strategy: AIStrategy = AgressiveStrategy()
        let bestMove = strategy.evaluateBestMove(actions, state: state)
        try? await Task.sleep(nanoseconds: UInt64(state.actionDelayMilliSeconds * 1_000_000))
        return bestMove
    }

    return nil
}
