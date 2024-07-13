//
//  SequenceState.swift
//  
//
//  Created by Hugues Telolahy on 06/07/2024.
//

import Redux

public struct SequenceState: Codable, Equatable {
    /// Queued effects
    public var queue: [GameAction]

    /// Pending action by player
    public var chooseOne: [String: ChooseOne]

    /// Playable cards by player
    public var active: [String: [String]]

    /// Current turn's number of times a card was played
    public var played: [String: Int]

    /// Game over
    public var winner: String?
}

/// Choice request
public struct ChooseOne: Codable, Equatable {
    public let type: ChoiceType
    public let options: [String]
}

/// ChooseOne context
public enum ChoiceType: String, Codable, Equatable {
    case target
    case cardToDraw
    case cardToSteal
    case cardToDiscard
    case cardToPassInPlay
    case cardToPutBack
    case cardToPlayCounter
}

/// ChooseOne options
public extension String {
    /// Hidden hand card
    static let hiddenHand = "hiddenHand"

    /// Pass when asked to do an action
    static let pass = "pass"
}

public extension SequenceState {
    enum Error: Swift.Error, Equatable {
        /// Expected game to be active
        case gameIsOver

        /// Expected to choose one of waited action
        case unwaitedAction

        /// Expected card to have play rule
        case cardNotPlayable(String)

        /// No shoot effect to counter
        case noShootToCounter
    }
}

public extension SequenceState {
    static let reducer: SelectorReducer<GameState, Self> = { state, action in
        let state = try prepareReducer(state.sequence, action)

        return switch action {
        case GameAction.activate:
            try activateReducer(state, action)

        case GameAction.chooseOne:
            try chooseOneReducer(state, action)

        case GameAction.setGameOver:
            try setGameOverReducer(state, action)

        case GameAction.startTurn:
            try startTurnReducer(state, action)

        case GameAction.eliminate:
            try eliminateReducer(state, action)

        default:
            state
        }
    }
}

private extension SequenceState {
    static let prepareReducer: ThrowingReducer<Self> = { state, action in
        // Game is over
        if state.winner != nil {
            throw Error.gameIsOver
        }

        var state = state

        // Pending choice
        if let chooseOne = state.chooseOne.first {
            guard case let GameAction.choose(option, player) = action,
                  player == chooseOne.key,
                  chooseOne.value.options.contains(option) else {
                throw Error.unwaitedAction
            }

            state.chooseOne.removeValue(forKey: chooseOne.key)
            return state
        }

        // Active cards
        if let active = state.active.first {
            guard case let GameAction.play(card, player) = action,
                  player == active.key,
                  active.value.contains(card) else {
                throw Error.unwaitedAction
            }

            state.active.removeValue(forKey: active.key)
            return state
        }

        // Resolving sequence
        if state.queue.first == (action as? GameAction) {
            state.queue.removeFirst()
        }

        return state
    }

    static let activateReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.activate(cards, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.active[player] = cards
        return state
    }

    static let chooseOneReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.chooseOne(type, options, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.chooseOne[player] = ChooseOne(
            type: type,
            options: options
        )
        return state
    }

    static let setGameOverReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.setGameOver(winner) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.winner = winner
        return state
    }

    static let startTurnReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.startTurn(player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.played = [:]
        return state
    }

    static let eliminateReducer: ThrowingReducer<Self> = { state, action in
        guard case let GameAction.eliminate(player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.queue.removeAll { $0.isEffectTriggeredBy(player) }
        return state
    }
}
