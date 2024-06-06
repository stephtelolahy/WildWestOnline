//
//  GameState+Reducer.swift
//
//
//  Created by Hugues Telolahy on 09/04/2023.
//

import Redux

public extension GameState {
    static let reducer: ReducerV1<Self> = { state, action in
        guard let action = action as? GameAction else {
            return state
        }

        var state = state
        state.event = nil
        state.error = nil
        do {
            state = try action.prepare(state: state)
            state = try action.reduce(state: state)
            if action.isRenderable {
                state.event = action
            }
        } catch {
            state.error = error as? GameError
            print("🚨 reduceAction: \(action)\tthrows: \(error)")
        }

        return state
    }
}

private extension GameAction {
    func prepare(state: GameState) throws -> GameState {
        var state = state

        // Game is over
        if state.winner != nil {
            throw GameError.gameIsOver
        }

        // Pending choice
        if let chooseOne = state.chooseOne.first {
            guard case let .choose(option, player) = self,
                  player == chooseOne.key,
                  chooseOne.value.options.contains(option) else {
                throw GameError.unwaitedAction
            }

            state.chooseOne.removeValue(forKey: chooseOne.key)
            return state
        }

        // Active cards
        if let active = state.active.first {
            guard case let .play(card, player) = self,
                  player == active.key,
                  active.value.contains(card) else {
                throw GameError.unwaitedAction
            }

            state.active.removeValue(forKey: active.key)
            return state
        }

        // Resolving sequence
        if state.sequence.first == self {
            state.sequence.removeFirst()
        }

        return state
    }
}
