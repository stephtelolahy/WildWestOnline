//
//  CardFilterMatcher.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 10/11/2024.
//

extension Card.Selector.CardFilter {
    func match(_ card: String, state: GameFeature.State, ctx: Card.Effect.Payload) -> Bool {
        matcher.match(card, state: state, ctx: ctx)
    }
}

private extension Card.Selector.CardFilter {
    protocol Matcher {
        func match(_ card: String, state: GameFeature.State, ctx: Card.Effect.Payload) -> Bool
    }

    var matcher: Matcher {
        switch self {
        case .canCounterShot: CanCounterShot()
        case .named(let name): Named(name: name)
        case .isFromHand: IsFromHand()
        }
    }

    struct CanCounterShot: Matcher {
        func match(_ card: String, state: GameFeature.State, ctx: Card.Effect.Payload) -> Bool {
            let cardName = Card.extractName(from: card)
            let cardObj = state.cards.get(cardName)
            return cardObj.canCounterShot
        }
    }

    struct Named: Matcher {
        let name: String

        func match(_ card: String, state: GameFeature.State, ctx: Card.Effect.Payload) -> Bool {
            Card.extractName(from: card) == name
        }
    }

    struct IsFromHand: Matcher {
        func match(_ card: String, state: GameFeature.State, ctx: Card.Effect.Payload) -> Bool {
            let playerObj = state.players.get(ctx.targetedPlayer!)
            return playerObj.hand.contains(card)
        }
    }
}
