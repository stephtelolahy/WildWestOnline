//
//  CardFilterMatcher.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 10/11/2024.
//

extension Card.Selector.CardFilter {
    func match(_ card: String, payload: Card.Effect.Payload, state: GameFeature.State) -> Bool {
        matcher.match(card, payload: payload, state: state)
    }
}

private extension Card.Selector.CardFilter {
    protocol Matcher {
        func match(_ card: String, payload: Card.Effect.Payload, state: GameFeature.State) -> Bool
    }

    var matcher: Matcher {
        switch self {
        case .canCounterShot: CanCounterShot()
        case .named(let name): Named(name: name)
        case .isFromHand: IsFromHand()
        }
    }

    struct CanCounterShot: Matcher {
        func match(_ card: String, payload: Card.Effect.Payload, state: GameFeature.State) -> Bool {
            let cardName = Card.extractName(from: card)
            let cardObj = state.cards.get(cardName)
            return cardObj.canCounterShot
        }
    }

    struct Named: Matcher {
        let name: String

        func match(_ card: String, payload: Card.Effect.Payload, state: GameFeature.State) -> Bool {
            Card.extractName(from: card) == name
        }
    }

    struct IsFromHand: Matcher {
        func match(_ card: String, payload: Card.Effect.Payload, state: GameFeature.State) -> Bool {
            let player = payload.targetedPlayer!
            let playerObj = state.players.get(player)
            return playerObj.hand.contains(card)
        }
    }
}
