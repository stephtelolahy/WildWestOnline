//
//  ActionPlayEquipment.swift
//  
//
//  Created by Hugues Telolahy on 10/06/2023.
//

struct ActionPlayEquipment: GameReducerProtocol {
    let player: String
    let card: String

    func reduce(state: GameState) throws -> GameState {
        // verify action
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName],
              let sideEffect = cardObj.rules.first(where: { $0.playReqs.contains(.onPlayEquipment) })?.effect else {
            throw GameError.cardNotPlayable(card)
        }

        // verify inPlay no duplication rule
        let playerObj = state.player(player)
        guard playerObj.inPlay.cards.allSatisfy({ $0.extractName() != cardName }) else {
            throw GameError.cardAlreadyInPlay(cardName)
        }

        // put card in play
        var state = state
        try state[keyPath: \GameState.players[player]]?.hand.remove(card)
        state[keyPath: \GameState.players[player]]?.inPlay.add(card)

        // save played card
        state.playCounter[card] = (state.playCounter[card] ?? 0) + 1

        // queue sideEffect
        let ctx: EffectContext = [.actor: player, .card: card]
        state.queue.insert(.resolve(sideEffect, ctx: ctx), at: 0)

        return state
    }
}
