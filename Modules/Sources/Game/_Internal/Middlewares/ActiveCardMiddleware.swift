// swiftlint:disable:this file_name
//  ActiveCardMiddleware.swift
//  
//
//  Created by Hugues Telolahy on 01/07/2023.
//

import Redux
import Combine

/// Dispatching active cards
let activeCardMiddleware: Middleware<GameState, GameAction> = { state, _ in
    guard let action = state.evaluateActive() else {
        return Empty().eraseToAnyPublisher()
    }

    return Just(action).eraseToAnyPublisher()
}

extension GameState {
    func evaluateActive() -> GameAction? {
        guard queue.isEmpty,
              isOver == nil,
              chooseOne == nil,
              !lastEventIsActiveCard,
              let actor = turn else {
            return nil
        }

        var activeCards: [String] = []
        let actorObj = player(actor)
        for card in (actorObj.hand.cards + actorObj.abilities + abilities)
        where isCardPlayable(card, actor: actor) {
            activeCards.append(card)
        }

        if activeCards.isNotEmpty {
            return GameAction.activateCard(player: actor, cards: activeCards)
        }
        return nil
    }

    private func isCardPlayable(_ card: String, actor: String) -> Bool {
        let cardName = card.extractName()
        guard let cardObj = cardRef[cardName] else {
            return false
        }

        guard cardObj.actions.contains(where: { $0.eventReq == .onPlay }) else {
            return false
        }

        let action = GameAction.play(card, actor: actor)
        do {
            try action.validate(state: self)
            return true
        } catch {
            print("!!! invalidate \(action) reason: \(error)")
            return false
        }
    }
}

private extension GameState {
    var lastEventIsActiveCard: Bool {
        switch event {
        case .activateCard:
            return true
        default:
            return false
        }
    }
}
