//
//  CardGroupResolver.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 19/11/2024.
//

extension Card.Selector.CardGroup {
    func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> [String] {
        try resolver.resolve(pendingAction, state: state)
    }
}

private extension Card.Selector.CardGroup {
    protocol Resolver {
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> [String]
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
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> [String] {
            state.players.get(pendingAction.targetedPlayer!).inPlay
        }
    }

    struct AllInHand: Resolver {
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> [String] {
            state.players.get(pendingAction.targetedPlayer!).hand
        }
    }

    struct Played: Resolver {
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> [String] {
            let card = pendingAction.playedCard!
            return [card]
        }
    }

    struct EquippedWeapon: Resolver {
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> [String] {
            state.players.get(pendingAction.targetedPlayer!).inPlay.filter { state.isWeapon($0) }
        }
    }
}

private extension GameFeature.State {
    func isWeapon(_ card: String) -> Bool {
        let cardName = Card.extractName(from: card)
        let cardObj = cards.get(cardName)
        let onActive = cardObj.behaviour[.equip] ?? []
        return onActive.contains { $0.name == .setWeapon }
    }
}
