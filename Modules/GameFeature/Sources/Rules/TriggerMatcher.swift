//
//  TriggerMatcher.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 26/07/2025.
//

extension Card.Trigger {
    func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool {
        matcher.match(action, card: card, player: player, state: state)
    }
}

private extension Card.Trigger {
    protocol Matcher {
        func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool
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
        case .turnStarted: TurnStarted()
        case .turnEnded: TurnEnded()
        case .shot: Shot()
        case .cardPrePlayed: NeverMatch()
        case .cardPlayed: NeverMatch()
        case .eliminating: Eliminating()
        }
    }

    struct NeverMatch: Matcher {
        func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool {
            false
        }
    }

    struct CardEquiped: Matcher {
        func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool {
            if case .equip = action.name,
               action.sourcePlayer == player,
               action.playedCard == card {
                return true
            }

            return false
        }
    }

    struct CardDiscarded: Matcher {
        func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool {
            if case .discardInPlay = action.name,
               action.targetedPlayer == player,
               action.targetedCard == card {
                return true
            }

            if case .stealInPlay = action.name,
               action.targetedPlayer == player,
               action.targetedCard == card {
                return true
            }

            return false
        }
    }

    struct Damaged: Matcher {
        func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool {
            if case .damage = action.name,
               action.targetedPlayer == player,
               state.players.get(player).health > 0 {
                return true
            }

            return false
        }
    }

    struct DamagedLethal: Matcher {
        func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool {
            if case .damage = action.name,
               action.targetedPlayer == player,
               state.players.get(player).health <= 0 {
                return true
            }

            return false
        }
    }

    struct Eliminated: Matcher {
        func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool {
            if case .eliminate = action.name,
               action.targetedPlayer == player {
                return true
            }

            return false
        }
    }

    struct HandEmptied: Matcher {
        func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool {
            if case .discardHand = action.name,
               action.targetedPlayer == player,
               state.players.get(player).hand.isEmpty {
                return true
            }

            if case .stealHand = action.name,
               action.targetedPlayer == player,
               state.players.get(player).hand.isEmpty {
                return true
            }

            if case .play = action.name,
               action.sourcePlayer == player,
               state.players.get(player).hand.isEmpty {
                return true
            }

            if case .equip = action.name,
               action.sourcePlayer == player,
               state.players.get(player).hand.isEmpty {
                return true
            }

            return false
        }
    }

    struct TurnStarted: Matcher {
        func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool {
            if case .startTurn = action.name,
               action.targetedPlayer == player {
                return true
            }

            return false
        }
    }

    struct TurnEnded: Matcher {
        func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool {
            if case .endTurn = action.name,
               action.targetedPlayer == player {
                return true
            }

            return false
        }
    }

    struct Shot: Matcher {
        func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool {
            if case .shoot = action.name,
               action.targetedPlayer == player {
                return true
            }

            return false
        }
    }

    struct Eliminating: Matcher {
        func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool {
            guard case .eliminate = action.name,
                  let parentAction = action.triggeredBy.first,
                  parentAction.name == .damage,
                  parentAction.sourcePlayer == player,
                  parentAction.targetedPlayer != player else {
                return false
            }

            return true
        }
    }
}
