//
//  ActionPlayImmediate.swift
//  
//
//  Created by Hugues Telolahy on 09/04/2023.
//

struct ActionPlayImmediate: GameReducerProtocol {
    let player: String
    let card: String
    let target: String?

    func reduce(state: GameState) throws -> GameState {
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName],
              var sideEffect = cardObj.actions[.onPlay(.immediate)] else {
            throw GameError.cardNotPlayable(card)
        }

        var ctx: EffectContext = [.actor: player, .card: card]
        ctx[.target] = target

        if case let .require(_, childEffect) = sideEffect {
            sideEffect = childEffect
        }

        if case let .target(requiredTarget, childEffect) = sideEffect {
            let resolvedTarget = try requiredTarget.resolve(state: state, ctx: ctx)
            if case .selectable = resolvedTarget {
                guard target != nil else {
                    throw GameError.noPlayer(.target)
                }
                sideEffect = childEffect
            }
        }

        var state = state

        // discard played hand card
        let playerObj = state.player(player)
        guard playerObj.hand.contains(card) else {
            throw GameError.cardNotFound(card)
        }
        
        try state[keyPath: \GameState.players[player]]?.hand.remove(card)
        state.discard.push(card)

        state.playCounter[card] = (state.playCounter[card] ?? 0) + 1
        
        state.queue.insert(.resolve(sideEffect, ctx: ctx), at: 0)
        return state
    }
}
