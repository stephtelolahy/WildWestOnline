//
//  SequenceReducer.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 15/09/2024.
//

import Redux
/*
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

        let effects = cardObj.triggered.filter { $0.when == .played }
        guard effects.isNotEmpty else {
            throw SequenceState.Error.cardNotPlayable(card)
        }

        /*
         TODO:
         // increment play counter
         let playedCount = state.played[cardName] ?? 0
         state.played[cardName] = playedCount + 1
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
        state.queue.insert(contentsOf: children, at: 0)

        return state
    }

    static let prepareEffectReducer: Reducer<GameState> = { state, action in
        guard case let GameAction.prepareEffect(effect) = action else {
            fatalError("unexpected")
        }

        var state = state
        let children = try effect.resolve(state: state)
        state.queue.insert(contentsOf: children, at: 0)
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
