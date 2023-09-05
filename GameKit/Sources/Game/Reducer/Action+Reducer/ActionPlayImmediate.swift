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
        // verify action
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName],
              var sideEffect = cardObj.rules.first(where: { $0.playReqs.contains(.onPlayImmediate) })?.effect else {
            throw GameError.cardNotPlayable(card)
        }

        // discard played hand card
        let playerObj = state.player(player)
        guard playerObj.hand.contains(card) else {
            throw GameError.cardNotFound(card)
        }

        var state = state
        try state[keyPath: \GameState.players[player]]?.hand.remove(card)
        state.discard.push(card)

        // save played card
        state.playCounter[card] = (state.playCounter[card] ?? 0) + 1
        
        // queue sideEffect
        var ctx: EffectContext = [.actor: player, .card: card]
        ctx[.target] = target
        if case let .target(requiredTarget, childEffect) = sideEffect {
            let resolvedTarget = try requiredTarget.resolve(state: state, ctx: ctx)
            if case .selectable = resolvedTarget {
                guard target != nil else {
                    throw GameError.noPlayer(.target)
                }
                sideEffect = childEffect
            }
        }
        state.queue.insert(.resolve(sideEffect, ctx: ctx), at: 0)
        return state
    }
}
