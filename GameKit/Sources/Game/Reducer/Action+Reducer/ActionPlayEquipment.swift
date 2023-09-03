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
        let playerObj = state.player(player)
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName],
              let sideEffect = cardObj.rules.first(where: { $0.eventReq == .onPlayEquipment })?.effect else {
            throw GameError.cardNotPlayable(card)
        }

        guard playerObj.inPlay.cards.allSatisfy({ $0.extractName() != cardName }) else {
            throw GameError.cardAlreadyInPlay(cardName)
        }

        var state = state

        try state[keyPath: \GameState.players[player]]?.hand.remove(card)
        state[keyPath: \GameState.players[player]]?.inPlay.add(card)

        state.playCounter[card] = (state.playCounter[card] ?? 0) + 1

        let ctx: EffectContext = [.actor: player, .card: card]
        state.queue.insert(.resolve(sideEffect, ctx: ctx), at: 0)

        return state
    }
}
