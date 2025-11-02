//
//  CardFilterMatcher.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 10/11/2024.
//

extension Card.Selector.CardFilter {
    func match(_ card: String, pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
        matcher.match(card, pendingAction: pendingAction, state: state)
    }
}

private extension Card.Selector.CardFilter {
    protocol Matcher {
        func match(_ card: String, pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool
    }

    var matcher: Matcher {
        switch self {
        case .canCounterShot: CanCounterShot()
        case .named(let name): Named(name: name)
        case .isFromHand: IsFromHand()
        }
    }

    struct CanCounterShot: Matcher {
        func match(_ card: String, pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
            let cardName = Card.name(of: card)
            let cardObj = state.cards.get(cardName)
            return cardObj.effects.contains { $0.trigger == .permanent && $0.action == .counterShot }
        }
    }

    struct Named: Matcher {
        let name: String

        func match(_ card: String, pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
            Card.name(of: card) == name
        }
    }

    struct IsFromHand: Matcher {
        func match(_ card: String, pendingAction: GameFeature.Action, state: GameFeature.State) -> Bool {
            guard let player = pendingAction.targetedPlayer else { fatalError("Missing targetedPlayer") }

            let playerObj = state.players.get(player)
            return playerObj.hand.contains(card)
        }
    }
}
