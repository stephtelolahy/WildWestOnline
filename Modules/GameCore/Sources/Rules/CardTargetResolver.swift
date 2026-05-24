//
//  CardTargetResolver.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 26/04/2026.
//

extension Card.Selector.CardTarget {
    func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String]? {
        resolver.resolve(pendingAction, state: state)
    }
}

private extension Card.Selector.CardTarget {
    protocol Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String]?
    }

    var resolver: Resolver {
        switch self {
        case .source: Source()
        case .equippedWeapon: EquippedWeapon()
        case .lastDrawn: LastDrawn()
        case .trigger: Trigger()
        case .every(let group): Every(group: group)
        }
    }

    struct Source: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String]? {
            [pendingAction.sourceCard]
        }
    }

    struct EquippedWeapon: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String]? {
            guard let target = pendingAction.targetedPlayer else { fatalError("Missing targetedPlayer") }

            guard let weapon = state.players.get(target).inPlay.first(where: { state.isWeapon($0) }) else {
                return nil
            }

            return [weapon]
        }
    }

    struct LastDrawn: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String]? {
            guard let target = pendingAction.targetedPlayer else { fatalError("Missing targetedPlayer") }
            guard let card = state.players.get(target).hand.last else { fatalError("Missing last card in hand of player \(target)") }

            return [card]
        }
    }

    struct Trigger: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String]? {
            guard let parentAction = pendingAction.triggeredBy.first,
                  let targetedCard = parentAction.targetedCard else {
                return nil
            }

            return [targetedCard]
        }
    }

    struct Every: Resolver {
        let group: Card.Selector.CardGroup

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String]? {
            group.resolve(pendingAction, state: state)
        }
    }
}

private extension GameFeature.State {
    func isWeapon(_ card: String) -> Bool {
        let cardName = Card.name(of: card)
        let cardObj = cards.get(cardName)
        return cardObj.effects.contains { $0.trigger == .equiped && $0.action == .setWeapon }
    }
}
