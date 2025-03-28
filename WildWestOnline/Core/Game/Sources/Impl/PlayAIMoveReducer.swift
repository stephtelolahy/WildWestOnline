//
//  PlayAIMoveReducer.swift
//
//  Created by Hugues Telolahy on 27/12/2024.
//
import Redux

public func playAIMoveReducer(
    state: inout GameFeature.State,
    action: ActionProtocol,
    dependencies: Void
) throws -> Effect {
    let state = state
    return .run {
        await playAIMove(state: state, action: action)
    }
}

private func playAIMove(state: GameFeature.State, action: ActionProtocol) async -> ActionProtocol? {
    if let pendingChoice = state.pendingChoice,
       state.playMode[pendingChoice.chooser] == .auto {
        let actions = pendingChoice.options.map { Card.Effect.choose($0.label, player: pendingChoice.chooser) }
        let strategy: AIStrategy = AgressiveStrategy()
        let bestMove = strategy.evaluateBestMove(actions, state: state)
        try? await Task.sleep(nanoseconds: UInt64(state.actionDelayMilliSeconds * 1_000_000))
        return bestMove
    }

    if state.active.isNotEmpty,
       let choice = state.active.first,
       state.playMode[choice.key] == .auto {
        let actions = choice.value.map { Card.Effect.preparePlay($0, player: choice.key) }
        let strategy: AIStrategy = AgressiveStrategy()
        let bestMove = strategy.evaluateBestMove(actions, state: state)
        try? await Task.sleep(nanoseconds: UInt64(state.actionDelayMilliSeconds * 1_000_000))
        return bestMove
    }

    return nil
}
