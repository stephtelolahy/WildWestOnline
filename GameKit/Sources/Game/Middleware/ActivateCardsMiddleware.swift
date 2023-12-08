//
//  ActivateCardsMiddleware.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//
import Combine
import Redux

public final class ActivateCardsMiddleware: Middleware<GameState> {
    override public func handle(action: Action, state: GameState) -> AnyPublisher<Action, Never>? {
        guard state.sequence.isEmpty,
              state.winner == nil,
              state.chooseOne == nil,
              state.active == nil,
              let player = state.turn else {
            return nil
        }

        var activeCards: [String] = []
        let playerObj = state.player(player)
        for card in activableCardsOfPlayer(playerObj)
        where GameAction.validatePlay(card: card, player: player, state: state) {
            activeCards.append(card)
        }

        // Ignore empty
        guard activeCards.isNotEmpty else {
            return nil
        }

        let activateAction = GameAction.activate(activeCards, player: player)
        return Just(activateAction).eraseToAnyPublisher()
    }

    private func activableCardsOfPlayer(_ playerObj: Player) -> [String] {
        playerObj.attributes.map(\.key) + playerObj.hand
    }
}
