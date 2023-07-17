//
//  ActionPlayImmediate.swift
//  
//
//  Created by Hugues Telolahy on 09/04/2023.
//

struct ActionPlayImmediate: GameReducerProtocol {
    let actor: String
    let card: String
    let target: String?

    func reduce(state: GameState) throws -> GameState {
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName],
              let playAction = cardObj.actions.first(where: { $0.eventReq == .onPlay }) else {
            throw GameError.cardNotPlayable(card)
        }

        var ctx: EffectContext = [.actor: actor, .card: card]
        ctx[.target] = target

        var sideEffect = playAction.effect
        
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
        let actorObj = state.player(actor)
        if actorObj.hand.contains(card) {
            try state[keyPath: \GameState.players[actor]]?.hand.remove(card)
            state.discard.push(card)
        }

        state.playCounter[card] = (state.playCounter[card] ?? 0) + 1
        
        state.queue.insert(.resolve(sideEffect, ctx: ctx), at: 0)
        return state
    }
}
