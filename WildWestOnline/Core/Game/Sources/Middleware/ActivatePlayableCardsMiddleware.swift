//
//  ActivatePlayableCardsMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//

import Combine
import Redux

extension Middlewares {
    static func activatePlayableCards() -> Middleware<GameState> {
        { state, _ in
            guard state.sequence.queue.isEmpty,
                  state.sequence.winner == nil,
                  state.sequence.chooseOne.isEmpty,
                  state.sequence.active.isEmpty,
                  let player = state.turn else {
                return Empty().eraseToAnyPublisher()
            }

            var activeCards: [String] = []
            let playerObj = state.player(player)
            let activableCards = playerObj.abilities + playerObj.hand
            for card in activableCards
            where GameAction.validatePlay(card: card, player: player, state: state) {
                activeCards.append(card)
            }

            // Ignore empty
            guard activeCards.isNotEmpty else {
                return Empty().eraseToAnyPublisher()
            }

            return Just(GameAction.activate(activeCards, player: player)).eraseToAnyPublisher()
        }
    }
}
