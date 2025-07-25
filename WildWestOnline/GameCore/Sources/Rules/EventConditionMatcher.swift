//
//  EventConditionMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 26/07/2025.
//

extension Card.EventCondition {
    func match(_ event: Card.Effect, player: String, state: GameFeature.State) -> Bool {
        matcher.match(event, player: player, state: state)
    }
}

private extension Card.EventCondition {
    protocol Matcher {
        func match(_ event: Card.Effect, player: String, state: GameFeature.State) -> Bool
    }

    var matcher: Matcher {
        switch self {
        case .handEmptied: HandEmptied()
        }
    }

    struct HandEmptied: Matcher {
        func match(_ event: Card.Effect, player: String, state: GameFeature.State) -> Bool {
            if case .discardHand = event.name,
               event.targetedPlayer == player, state.players
                .get(player).hand.isEmpty {
                return true
            }

            return false
        }
    }
}
