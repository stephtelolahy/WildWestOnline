//
//  ActivateCardsMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//

import Redux

public final class ActivateCardsMiddleware: Middleware<GameState> {
    override public func effect(on action: Action, state: GameState) async -> Action? {
        guard state.sequence.isEmpty,
              state.winner == nil,
              state.chooseOne.isEmpty,
              state.active.isEmpty,
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

        return GameAction.activate(activeCards, player: player)
    }

    private func activableCardsOfPlayer(_ playerObj: Player) -> [String] {
        playerObj.abilities + playerObj.hand
    }
}
