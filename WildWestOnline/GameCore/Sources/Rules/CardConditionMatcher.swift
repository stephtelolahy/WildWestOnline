//
//  CardConditionMatcher.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 10/11/2024.
//

extension Card.Selector.CardCondition {
    func match(_ card: String, state: GameFeature.State, ctx: Card.Effect.Payload) -> Bool {
        matcher.match(card, state: state, ctx: ctx)
    }
}

private extension Card.Selector.CardCondition {
    protocol Matcher {
        func match(_ card: String, state: GameFeature.State, ctx: Card.Effect.Payload) -> Bool
    }

    var matcher: Matcher {
        switch self {
        case .canCounterShot: CanCounterShot()
        case .named(let name): Named(name: name)
        case .fromHand: FromHand()
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

    struct FromHand: Matcher {
        func match(_ card: String, state: GameFeature.State, ctx: Card.Effect.Payload) -> Bool {
            let playerObj = state.players.get(ctx.target!)
            return playerObj.hand.contains(card)
        }
    }
}
