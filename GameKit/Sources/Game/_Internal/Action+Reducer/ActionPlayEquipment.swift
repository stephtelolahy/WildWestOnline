//
//  ActionPlayEquipment.swift
//  
//
//  Created by Hugues Telolahy on 10/06/2023.
//

struct ActionPlayEquipment: GameReducerProtocol {
    let actor: String
    let card: String

    func reduce(state: GameState) throws -> GameState {
        let actorObj = state.player(actor)
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName],
              let sideEffect = cardObj.actions[.onPlay(.equipment)] else {
            throw GameError.cardNotPlayable(card)
        }

        guard actorObj.inPlay.cards.allSatisfy({ $0.extractName() != cardName }) else {
            throw GameError.cardAlreadyInPlay(cardName)
        }

        var state = state

        try state[keyPath: \GameState.players[actor]]?.hand.remove(card)
        state[keyPath: \GameState.players[actor]]?.inPlay.add(card)

        state.playCounter[card] = (state.playCounter[card] ?? 0) + 1

        let ctx: EffectContext = [.actor: actor, .card: card]
        state.queue.insert(.resolve(sideEffect, ctx: ctx), at: 0)

        return state
    }
}
