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
        case .equiped: Equiped()
        case .discarded: Discarded()
        case .damaged: Damaged()
        case .lethallyDamaged: LethallyDamaged()
        case .eliminated: Eliminated()
        case .handEmptied: HandEmptied()
        case .turnStarted: TurnStarted()
        case .turnEnded: TurnEnded()
        case .shot: Shot()
        case .prePlayed: NeverMatch()
        case .played: NeverMatch()
        case .eliminatingOther: EliminatingOther()
        case .otherEliminated: OtherEliminated()
        case .drawLastCardOnTurnStarted: DrawLastCardOnTurnStarted()
        case .weaponPrePlayed: WeaponPrePlayed()
        case .shootingWithCard(let name): ShootingWithCard(name: name)
        case .drawRequired: DrawRequired()
        case .prePlayingCard(named: let name): PrePlayingCard(name: name)
        case .hasStealHandOnTurnStarted: HasStealHandOnTurnStarted()
        case .hasDrawDiscardOnTurnStarted: HasDrawDiscardOnTurnStarted()
        }
    }

    struct NeverMatch: Matcher {
        func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool {
            false
        }
    }

    struct Equiped: Matcher {
        func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool {
            if case .equip = action.name,
               action.sourcePlayer == player,
               action.sourceCard == card {
                return true
            }

            return false
        }
    }

    struct Discarded: Matcher {
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

    struct LethallyDamaged: Matcher {
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

    struct EliminatingOther: Matcher {
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

    struct OtherEliminated: Matcher {
        func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool {
            guard case .eliminate = action.name,
                  action.targetedPlayer != player else {
                return false
            }

            return true
        }
    }

    struct DrawLastCardOnTurnStarted: Matcher {
        func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool {
            guard case .drawDeck = action.name,
                  action.targetedPlayer == player,
                  state.queue.isEmpty,
                  let parentAction = action.triggeredBy.first,
                  parentAction.name == .startTurn else {
                return false
            }

            return true
        }
    }

    struct WeaponPrePlayed: Matcher {
        func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool {
            guard case .preparePlay = action.name,
                  action.sourcePlayer == player else {
                return false
            }

            let cardName = Card.name(of: action.sourceCard)
            let cardObj = state.cards.get(cardName)
            return cardObj.effects.contains { $0.action == .setWeapon }
        }
    }

    struct ShootingWithCard: Matcher {
        let name: String

        func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool {
            guard case .shoot = action.name,
                  action.sourcePlayer == player,
                  let parent = action.triggeredBy.first,
                  parent.name == .play else {
                return false
            }

            let cardName = Card.name(of: parent.sourceCard)
            return cardName == name
        }
    }

    struct PrePlayingCard: Matcher {
        let name: String

        func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool {
            guard case .preparePlay = action.name,
                  Card.name(of: action.sourceCard) == name else {
                return false
            }

            return true
        }
    }

    struct DrawRequired: Matcher {
        func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool {
            guard case .draw = action.name,
                  action.targetedPlayer == player  else {
                return false
            }

            if state.events.count > 1,
                case .draw = state.events[1].name {
                return false
            }

            return true
        }
    }

    struct HasStealHandOnTurnStarted: Matcher {
        func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool {
            guard case .stealHand = action.name,
                  action.sourcePlayer == player  else {
                return false
            }

            guard case .startTurn = action.triggeredBy.first?.name else {
                return false
            }

            return true
        }
    }

    struct HasDrawDiscardOnTurnStarted: Matcher {
        func match(_ action: GameFeature.Action, card: String, player: String, state: GameFeature.State) -> Bool {
            guard case .drawDiscard = action.name,
                  action.targetedPlayer == player  else {
                return false
            }

            guard case .startTurn = action.triggeredBy.first?.name else {
                return false
            }

            return true
        }
    }
}
