//
//  TriggerMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 26/07/2025.
//

extension Card.Trigger {
    func match(_ event: Card.Effect, card: String, player: String, state: GameFeature.State) -> Bool {
        matcher.match(event, card: card, player: player, state: state)
    }
}

private extension Card.Trigger {
    protocol Matcher {
        func match(_ event: Card.Effect, card: String, player: String, state: GameFeature.State) -> Bool
    }

    var matcher: Matcher {
        switch self {
        case .permanent: NeverMatch()
        case .cardEquiped: CardEquiped()
        case .cardDiscarded: CardDiscarded()
        case .damaged: Damaged()
        case .damagedLethal: DamagedLethal()
        case .eliminated: Eliminated()
        case .handEmptied: HandEmptied()
        }
    }

    struct NeverMatch: Matcher {
        func match(_ event: Card.Effect, card: String, player: String, state: GameFeature.State) -> Bool {
            false
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

    struct Damaged: Matcher {
        func match(_ event: Card.Effect, card: String, player: String, state: GameFeature.State) -> Bool {
            if case .damage = event.name,
               event.targetedPlayer == player,
               state.players.get(player).health > 0 {
                return true
            }

            return false
        }
    }

    struct DamagedLethal: Matcher {
        func match(_ event: Card.Effect, card: String, player: String, state: GameFeature.State) -> Bool {
            if case .damage = event.name,
               event.targetedPlayer == player,
               state.players.get(player).health <= 0 {
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
