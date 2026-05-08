//
//  CardRefResolver.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 26/04/2026.
//

extension Card.Selector.CardRef {
    func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> String? {
        resolver.resolve(pendingAction, state: state)
    }
}

private extension Card.Selector.CardRef {
    protocol Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> String?
    }

    var resolver: Resolver {
        switch self {
        case .played: Played()
        case .equippedWeapon: EquippedWeapon()
        case .lastDrawn: LastDrawn()
        }
    }

    struct Played: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> String? {
            pendingAction.sourceCard
        }
    }

    struct EquippedWeapon: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> String? {
            guard let target = pendingAction.targetedPlayer else { fatalError("Missing targetedPlayer") }

            return state.players.get(target).inPlay.first { state.isWeapon($0) }
        }
    }

    struct LastDrawn: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> String? {
            guard let target = pendingAction.targetedPlayer else { fatalError("Missing targetedPlayer") }
            guard let card = state.players.get(target).hand.last else { fatalError("Missing last card in hand of player \(target)") }

            return card
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
