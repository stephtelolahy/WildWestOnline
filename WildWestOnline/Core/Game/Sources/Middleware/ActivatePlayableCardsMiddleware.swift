// swiftlint:disable:this file_name
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
            guard state.sequence.isEmpty,
                  state.winner == nil,
                  state.chooseOne.isEmpty,
                  state.active.isEmpty,
                  let player = state.turn else {
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
