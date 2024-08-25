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

/// Context data associated to an effect
public struct EffectContext: Codable, Equatable {
    /// Occurred event triggering the effect
    let sourceEvent: GameAction

    /// Owner of the card triggering the effect
    let sourceActor: String

    /// Card triggering the effect
    let sourceCard: String

    /// Targeted player while resolving the effect
    var resolvingTarget: String?

    /// Chooser player while resolving the effect
    var resolvingChooser: String?

    /// Chosen option while resolving effect
    var resolvingOption: String?
}

public extension EffectContext {
    /// Shot player triggering this effect
    /// The cancelation of the shoot results in the cancelation of the effect
    var sourceShoot: String? {
        guard case let .prepareEffect(cardEffect, ctx) = sourceEvent,
              case .shoot = cardEffect else {
            return nil
        }

        return ctx.resolvingTarget
    }
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
    static let reducer: SelectorReducer<GameState, Self, GameAction> = { state, action in
        var state = state
        state.sequence = try prepareReducer(state.sequence, action)

        return switch action {
        case .activate:
            try activateReducer(state.sequence, action)

        case .chooseOne:
            try chooseOneReducer(state.sequence, action)

        case .prepareChoose:
            try chooseReducer(state.sequence, action)

        case .endGame:
            try setGameOverReducer(state.sequence, action)

        case .startTurn:
            try startTurnReducer(state.sequence, action)

        case .eliminate:
            try eliminateReducer(state.sequence, action)

        case .group:
            try groupReducer(state.sequence, action)

        case .preparePlay:
            try playReducer(state, action)

        case .prepareEffect:
            try effectReducer(state, action)

        default:
            state.sequence
        }
    }
}

private extension SequenceState {
    static let prepareReducer: Reducer<Self, GameAction> = { state, action in
        // Game is over
        if state.winner != nil {
            throw Error.gameIsOver
        }

        var state = state

        // Pending choice
        if let chooseOne = state.chooseOne.first {
            guard case let .prepareChoose(option, player) = action,
                  player == chooseOne.key,
                  chooseOne.value.options.contains(option) else {
                throw Error.unwaitedAction
            }

            state.chooseOne.removeValue(forKey: chooseOne.key)
            return state
        }

        // Active cards
        if let active = state.active.first {
            guard case let .preparePlay(card, player) = action,
                  player == active.key,
                  active.value.contains(card) else {
                throw Error.unwaitedAction
            }

            state.active.removeValue(forKey: active.key)
            return state
        }

        // Resolving sequence
        if state.queue.isNotEmpty,
           state.queue.first == action {
            state.queue.removeFirst()
        }

        return state
    }

    static let activateReducer: Reducer<Self, GameAction> = { state, action in
        guard case let .activate(cards, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.active[player] = cards
        return state
    }

    static let chooseOneReducer: Reducer<Self, GameAction> = { state, action in
        guard case let .chooseOne(type, options, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.chooseOne[player] = ChooseOne(
            type: type,
            options: options
        )
        return state
    }

    static let chooseReducer: Reducer<Self, GameAction> = { state, action in
        guard case let .prepareChoose(option, player) = action else {
            fatalError("unexpected")
        }

        guard let nextAction = state.queue.first,
              case let .prepareEffect(cardEffect, ctx) = nextAction,
              case .matchAction = cardEffect else {
            fatalError("Next action should be an effect.matchAction")
        }

        var updatedContext = ctx
        updatedContext.resolvingOption = option
        let updatedAction = GameAction.prepareEffect(cardEffect, ctx: updatedContext)
        var state = state
        state.queue[0] = updatedAction

        return state
    }

    static let setGameOverReducer: Reducer<Self, GameAction> = { state, action in
        guard case let .endGame(winner) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.winner = winner
        return state
    }

    static let startTurnReducer: Reducer<Self, GameAction> = { state, action in
        guard case let .startTurn(player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.played = [:]
        return state
    }

    static let eliminateReducer: Reducer<Self, GameAction> = { state, action in
        guard case let .eliminate(player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.queue.removeAll { $0.isEffectTriggeredBy(player) }
        return state
    }

    static let playReducer: SelectorReducer<GameState, Self, GameAction> = { state, action in
        guard case let .preparePlay(card, player) = action else {
            fatalError("unexpected")
        }

        // <resolve card alias>
        var cardName = card.extractName()
        let event = GameAction.preparePlay(card, player: player)
        let playReqContext = PlayReqContext(actor: player, event: event)
        if let alias = state.aliasWhenPlayingCard(card, player: player, ctx: playReqContext) {
            cardName = alias
        }
        // </resolve card alias>

        guard let cardObj = state.cards[cardName] else {
            throw SequenceState.Error.cardNotPlayable(card)
        }

        let playRules = cardObj.rules.filter { $0.playReqs.contains(.play) }
        guard playRules.isNotEmpty else {
            throw SequenceState.Error.cardNotPlayable(card)
        }

        // verify requirements
        for playRule in playRules {
            for playReq in playRule.playReqs where playReq != .play {
                try playReq.throwingMatch(state: state, ctx: playReqContext)
            }
        }

        var sequence = state.sequence

        // increment play counter
        let playedCount = sequence.played[cardName] ?? 0
        sequence.played[cardName] = playedCount + 1

        // queue play effects
        let ctx = EffectContext(sourceEvent: event, sourceActor: player, sourceCard: card)
        let children: [GameAction] = playRules.map { .prepareEffect($0.effect, ctx: ctx) }
        sequence.queue.insert(contentsOf: children, at: 0)

        return sequence
    }

    static let effectReducer: SelectorReducer<GameState, Self, GameAction> = { state, action in
        guard case let .prepareEffect(effect, ctx) = action else {
            fatalError("unexpected")
        }

        var sequence = state.sequence
        let output = try effect.resolve(state: state, ctx: ctx)
        switch output {
        case let .push(children):
            sequence.queue.insert(contentsOf: children, at: 0)

        case let .cancel(actions):
            for action in actions {
                sequence.cancel(action)
            }

        case let .replace(index, updatedAction):
            sequence.queue[index] = updatedAction

        case .nothing:
            break
        }

        return sequence
    }

    static let groupReducer: Reducer<Self, GameAction> = { state, action in
        guard case let .group(children) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.queue.insert(contentsOf: children, at: 0)
        return state
    }
}

private extension SequenceState {
    mutating func cancel(_ action: GameAction) {
        if let index = queue.firstIndex(of: action) {
            queue.remove(at: index)
            removeEffectsLinkedTo(action)
        }
    }

    mutating func removeEffectsLinkedTo(_ action: GameAction) {
        if case let .prepareEffect(effect, effectCtx) = action,
           case .prepareShoot = effect,
           let target = effectCtx.resolvingTarget {
            removeEffectsLinkedToShoot(target)
        }
    }

    mutating func removeEffectsLinkedToShoot(_ target: String) {
        queue.removeAll { item in
            if case let .prepareEffect(_, ctx) = item,
               ctx.sourceShoot == target {
                return true
            } else {
                return false
            }
        }
    }
}
