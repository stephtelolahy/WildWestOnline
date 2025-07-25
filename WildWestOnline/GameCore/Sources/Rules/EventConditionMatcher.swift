//
//  EventConditionMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 26/07/2025.
//

extension Card.EventCondition {
    func match(_ event: Card.Effect, card: String, player: String, state: GameFeature.State) -> Bool {
        matcher.match(event, card: card, player: player, state: state)
    }
}

private extension Card.EventCondition {
    protocol Matcher {
        func match(_ event: Card.Effect, card: String, player: String, state: GameFeature.State) -> Bool
    }

    var matcher: Matcher {
        switch self {
        case .cardEquiped: CardEquiped()
        case .cardDiscarded: CardDiscarded()
        case .eliminated: Eliminated()
        case .handEmptied: HandEmptied()
        }
    }

    struct CardEquiped: Matcher {
        func match(_ event: Card.Effect, card: String, player: String, state: GameFeature.State) -> Bool {
            if case .equip = event.name,
               event.sourcePlayer == player,
               event.playedCard == card {
                return true
            }

            return false
        }
    }

    struct CardDiscarded: Matcher {
        func match(_ event: Card.Effect, card: String, player: String, state: GameFeature.State) -> Bool {
            if case .discardInPlay = event.name,
               event.targetedPlayer == player,
               event.targetedCard == card {
                return true
            }

            if case .stealInPlay = event.name,
               event.targetedPlayer == player,
               event.targetedCard == card {
                return true
            }

            return false
        }
    }

    struct Eliminated: Matcher {
        func match(_ event: Card.Effect, card: String, player: String, state: GameFeature.State) -> Bool {
            if case .eliminate = event.name,
               event.targetedPlayer == player {
                return true
            }

            return false
        }
    }

    struct HandEmptied: Matcher {
        func match(_ event: Card.Effect, card: String, player: String, state: GameFeature.State) -> Bool {
            if case .discardHand = event.name,
               event.targetedPlayer == player,
               state.players.get(player).hand.isEmpty {
                return true
            }

            if case .stealHand = event.name,
               event.targetedPlayer == player,
               state.players.get(player).hand.isEmpty {
                return true
            }

            if case .play = event.name,
               event.sourcePlayer == player,
               state.players.get(player).hand.isEmpty {
                return true
            }

            if case .equip = event.name,
               event.sourcePlayer == player,
               state.players.get(player).hand.isEmpty {
                return true
            }

            return false
        }
    }
}
