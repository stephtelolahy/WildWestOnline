//
//  ActivatePlayableCardsMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//

import Redux

extension Middlewares {
    static func activatePlayableCards() -> Middleware<GameState> {
        { state, _ in
            guard state.sequence.queue.isEmpty,
                  state.sequence.winner == nil,
                  state.sequence.chooseOne.isEmpty,
                  state.sequence.active.isEmpty,
                  let player = state.round.turn else {
                return nil
            }

            var activeCards: [String] = []
            let playerObj = state.player(player)
            let activableCards = playerObj.abilities + state.field.hand.get(player)
            for card in activableCards
            where GameAction.validatePlay(card: card, player: player, state: state) {
                activeCards.append(card)
            }

            // Ignore empty
            guard activeCards.isNotEmpty else {
                return nil
            }

            return GameAction.activate(activeCards, player: player)
        }
    }
}
