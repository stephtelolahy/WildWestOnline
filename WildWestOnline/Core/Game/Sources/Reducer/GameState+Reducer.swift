//
//  GameState+Reducer.swift
//
//
//  Created by Hugues Telolahy on 09/04/2023.
//

import Redux

public extension GameState {
    static let reducer: Reducer<Self> = { state, action in
        guard let action = action as? GameAction else {
            return state
        }

        // TODO: startTurn
        // state.playedThisTurn = [:]

        // TODO: eliminate
        // state.sequence.removeAll { $0.isEffectTriggeredBy(player) }

        var state = state
        do {
            state = try action.prepare(state: state)
            state = try action.reduce(state: state)
        } catch {
            print("🚨 reduceAction: \(action)\tthrows: \(error)")
        }

        return state
    }
}

private extension GameAction {
    func prepare(state: GameState) throws -> GameState {
        var state = state

        // Game is over
        if state.sequence.winner != nil {
            throw GameError.gameIsOver
        }

        // Pending choice
        if let chooseOne = state.sequence.chooseOne.first {
            guard case let .choose(option, player) = self,
                  player == chooseOne.key,
                  chooseOne.value.options.contains(option) else {
                throw GameError.unwaitedAction
            }

            state.sequence.chooseOne.removeValue(forKey: chooseOne.key)
            return state
        }

        // Active cards
        if let active = state.sequence.active.first {
            guard case let .play(card, player) = self,
                  player == active.key,
                  active.value.contains(card) else {
                throw GameError.unwaitedAction
            }

            state.sequence.active.removeValue(forKey: active.key)
            return state
        }

        // Resolving sequence
        if state.sequence.queue.first == self {
            state.sequence.queue.removeFirst()
        }

        return state
    }
}
