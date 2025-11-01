//
//  CardGroupResolver.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 19/11/2024.
//
// swiftlint:disable force_unwrapping

extension Card.Selector.CardGroup {
    func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [String] {
        try resolver.resolve(pendingAction, state: state)
    }
}

private extension Card.Selector.CardGroup {
    protocol Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [String]
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
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [String] {
            state.players.get(pendingAction.targetedPlayer!).inPlay
        }
    }

    struct AllInHand: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [String] {
            state.players.get(pendingAction.targetedPlayer!).hand
        }
    }

    struct Played: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [String] {
            [pendingAction.playedCard]
        }
    }

    struct EquippedWeapon: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [String] {
            state.players.get(pendingAction.targetedPlayer!).inPlay.filter { state.isWeapon($0) }
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
