//
//  CardGroupResolver.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 19/11/2024.
//

extension Card.Selector.CardGroup {
    func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String] {
        resolver.resolve(pendingAction, state: state)
    }
}

private extension Card.Selector.CardGroup {
    protocol Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String]
    }

    var resolver: Resolver {
        switch self {
        case .played: Played()
        case .allInHand: AllInHand()
        case .allInPlay: AllInPlay()
        case .equippedWeapon: EquippedWeapon()
        }
    }

    struct AllInPlay: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String] {
            guard let target = pendingAction.targetedPlayer else { fatalError("Missing targetedPlayer") }

            return state.players.get(target).inPlay
        }
    }

    struct AllInHand: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String] {
            guard let target = pendingAction.targetedPlayer else { fatalError("Missing targetedPlayer") }

            return state.players.get(target).hand
        }
    }

    struct Played: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String] {
            [pendingAction.playedCard]
        }
    }

    struct EquippedWeapon: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String] {
            guard let target = pendingAction.targetedPlayer else { fatalError("Missing targetedPlayer") }

            return state.players.get(target).inPlay.filter { state.isWeapon($0) }
        }
    }
}

private extension GameFeature.State {
    func isWeapon(_ card: String) -> Bool {
        let cardName = Card.name(of: card)
        let cardObj = cards.get(cardName)
        return cardObj.effects.contains { $0.trigger == .cardEquiped && $0.action == .setWeapon }
    }
}
