// swiftlint:disable:this file_name
//  ActiveCardMiddleware.swift
//  
//
//  Created by Hugues Telolahy on 01/07/2023.
//

import Redux
import Combine

/// Dispatching active cards
public let activeCardMiddleware: Middleware<GameState> = { state, _ in
    if let action = state.evaluateActive() {
        Just(action).eraseToAnyPublisher()
    } else {
        Empty().eraseToAnyPublisher()
    }
}

private extension GameState {
    func evaluateActive() -> GameAction? {
        guard queue.isEmpty,
              isOver == nil,
              chooseOne == nil,
              !lastEventIsActiveCard,
              let player = turn else {
            return nil
        }
        
        var activeCards: [String] = []
        let playerObj = self.player(player)
        for card in (playerObj.hand.cards + playerObj.abilities + abilities)
        where isCardPlayable(card, player: player) {
            activeCards.append(card)
        }
        
        if activeCards.isNotEmpty {
            return GameAction.activateCards(player: player, cards: activeCards)
        }
        return nil
    }
    
    func isCardPlayable(_ card: String, player: String) -> Bool {
        let cardName = card.extractName()
        guard let cardObj = cardRef[cardName] else {
            return false
        }
        
        guard cardObj.actions[.onPlayImmediate] != nil
                || cardObj.actions[.onPlayAbility] != nil
                || cardObj.actions[.onPlayEquipment] != nil
                || cardObj.actions[.onPlayHandicap] != nil else {
            return false
        }
        
        let action = GameAction.play(card, player: player)
        do {
            try action.validate(state: self)
            return true
        } catch {
            print("!!! invalidate \(action)\treason: \(error)")
            return false
        }
    }
    
    var lastEventIsActiveCard: Bool {
        switch event {
        case .activateCards:
            true
        default:
            false
        }
    }
}
