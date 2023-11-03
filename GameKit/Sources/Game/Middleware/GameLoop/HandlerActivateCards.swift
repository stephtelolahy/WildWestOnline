//
//  HandlerActivateCards.swift
//  
//
//  Created by Hugues Telolahy on 03/11/2023.
//

struct HandlerActivateCards: GameActionHandler {
    func handle(action: GameAction, state: GameState) -> GameAction? {
        guard state.queue.isEmpty,
              state.isOver == nil,
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

        return .activateCards(player: player, cards: activeCards)
    }

    private func activableCardsOfPlayer(_ playerObj: Player) -> [String] {
        playerObj.abilities + playerObj.hand.cards
    }
}
