//
//  SequenceReducer.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//

import Redux

public extension SequenceState {
    static let reducer: Reducer<GameState> = { state, action in
        var state = state
        state.sequence = try prepareReducer(state.sequence, action)

        switch action {
        case GameAction.activate:
            state.sequence = try activateReducer(state.sequence, action)

        case GameAction.chooseOne:
            state.sequence = try chooseOneReducer(state.sequence, action)

        case GameAction.prepareChoose:
            state.sequence = try prepareChooseReducer(state.sequence, action)

        case GameAction.endGame:
            state.sequence = try endGameReducer(state.sequence, action)

        case GameAction.startTurn:
            state.sequence = try startTurnReducer(state.sequence, action)

        case GameAction.eliminate:
            state.sequence = try eliminateReducer(state.sequence, action)

        case GameAction.queue:
            state.sequence = try queueReducer(state.sequence, action)

        case GameAction.preparePlay:
            state.sequence = try preparePlayReducer(state, action).sequence

        case GameAction.prepareEffect:
            state.sequence = try prepareEffectReducer(state, action).sequence

        default:
            break
        }

        return state
    }
}

private extension SequenceState {
    static let prepareReducer: Reducer<Self> = { state, action in
        guard let action = action as? GameAction else {
            return state
        }

        // Game is over
        if state.winner != nil {
            throw Error.gameIsOver
        }

        var state = state

        // Pending choice
        if let chooseOne = state.chooseOne.first {
            guard case let GameAction.prepareChoose(option, player) = action,
                  player == chooseOne.key,
                  chooseOne.value.options.contains(option) else {
                throw Error.unwaitedAction
            }

            state.chooseOne.removeValue(forKey: chooseOne.key)
            return state
        }

        // Active cards
        if let active = state.active.first {
            guard case let GameAction.preparePlay(card, player) = action,
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

    static let activateReducer: Reducer<Self> = { state, action in
        guard case let GameAction.activate(cards, player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.active[player] = cards
        return state
    }

    static let chooseOneReducer: Reducer<Self> = { state, action in
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

    static let prepareChooseReducer: Reducer<Self> = { state, action in
        /*
        guard case let GameAction.prepareChoose(option, player) = action else {
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
         */
        return state
    }

    static let endGameReducer: Reducer<Self> = { state, action in
        guard case let GameAction.endGame(winner) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.winner = winner
        return state
    }

    static let startTurnReducer: Reducer<Self> = { state, action in
        guard case let GameAction.startTurn(player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.played = [:]
        return state
    }

    static let eliminateReducer: Reducer<Self> = { state, action in
        guard case let GameAction.eliminate(player) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.queue.removeAll { $0.isEffectTriggeredBy(player) }
        return state
    }

    static let preparePlayReducer: Reducer<GameState> = { state, action in
        guard case let GameAction.preparePlay(card, player) = action else {
            fatalError("unexpected")
        }

        var cardName = card.extractName()
        /*
         let playReqContext = PlayReqContext(actor: player, event: event)
         // <resolve card alias>
         if let alias = state.aliasWhenPlayingCard(card, player: player, ctx: playReqContext) {
         cardName = alias
         }
         // </resolve card alias>
         */

        guard let cardObj = state.cards[cardName] else {
            throw SequenceState.Error.cardNotPlayable(card)
        }

        let effects = cardObj.effects.filter { $0.when == .played }
        guard effects.isNotEmpty else {
            throw SequenceState.Error.cardNotPlayable(card)
        }

        /*
         TODO:
         // increment play counter
         let playedCount = state.sequence.played[cardName] ?? 0
         state.sequence.played[cardName] = playedCount + 1
         */

        // queue play effects
        var state = state
        let children: [GameAction] = effects.map {
            .prepareEffect(
                .init(
                    action: $0.action,
                    card: card,
                    actor: player,
                    event: .preparePlay(card, player: player),
                    selectors: $0.selectors
                )
            )
        }
        state.sequence.queue.insert(contentsOf: children, at: 0)

        return state
    }

    static let prepareEffectReducer: Reducer<GameState> = { state, action in
        guard case let GameAction.prepareEffect(effect) = action else {
            fatalError("unexpected")
        }

        var state = state
        let children = try effect.resolve(state: state)
        state.sequence.queue.insert(contentsOf: children, at: 0)
        return state
    }

    static let queueReducer: Reducer<Self> = { state, action in
        guard case let GameAction.queue(children) = action else {
            fatalError("unexpected")
        }

        var state = state
        state.queue.insert(contentsOf: children, at: 0)
        return state
    }
}
/*
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
*/
