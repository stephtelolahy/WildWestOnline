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

        guard state.isOver == nil else {
            return state
        }

        var state = state
        do {
            state = try action.prepare(state: state)
            state = try action.reduce(state: state)
            state.event = action
            state.error = nil
        } catch {
            state.error = error as? GameError
            state.event = nil
        }

        return state
    }
}

private extension GameAction {
    func prepare(state: GameState) throws -> GameState {
        var state = state

        if let chooseOne = state.chooseOne {
            guard chooseOne.options.values.contains(self) else {
                throw GameError.unwaitedAction
            }
            state.chooseOne = nil
        } else if let active = state.active {
            guard case let .play(card, player) = self,
                  active.player == player,
                  active.cards.contains(card) else {
                throw GameError.unwaitedAction
            }
            state.active = nil
        } else if state.queue.first == self {
            state.queue.removeFirst()
        }

        return state
    }
}
