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
        }
    }

    struct CounterShot: Matcher {
        func match(_ card: String, state: GameState, ctx: GameAction.Payload) -> Bool {
            // TODO: match a counterShot card
            Card.extractName(from: card) == "missed"
        }
    }
}
