//
//  CardConditionMatcher.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 10/11/2024.
//

extension ActionSelector.CardCondition {
    func match(_ card: String, state: GameState, ctx: GameAction.Payload) -> Bool {
        matcher.match(card, state: state, ctx: ctx)
    }
}

private extension ActionSelector.CardCondition {
    protocol Matcher {
        func match(_ card: String, state: GameState, ctx: GameAction.Payload) -> Bool
    }

    var matcher: Matcher {
        switch self {
        case .counterShot: CounterShot()
        case .named(let name): Named(name: name)
        case .fromHand: FromHand()
        }
    }

    struct CounterShot: Matcher {
        func match(_ card: String, state: GameState, ctx: GameAction.Payload) -> Bool {
            let cardName = Card.extractName(from: card)
            let cardObj = state.cards.get(cardName)
            return cardObj.counterShot
        }
    }

    struct Named: Matcher {
        let name: String

        func match(_ card: String, state: GameState, ctx: GameAction.Payload) -> Bool {
            Card.extractName(from: card) == name
        }
    }

    struct FromHand: Matcher {
        func match(_ card: String, state: GameState, ctx: GameAction.Payload) -> Bool {
            fatalError()
        }
    }
}
