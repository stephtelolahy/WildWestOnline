//
//  CardGroupResolver.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 19/11/2024.
//

extension Card.Selector.CardGroup {
    func resolve(_ state: GameFeature.State, ctx: Card.Effect.Payload) throws(Card.Failure) -> [String] {
        try resolver.resolve(state, ctx: ctx)
    }
}

private extension Card.Selector.CardGroup {
    protocol Resolver {
        func resolve(_ state: GameFeature.State, ctx: Card.Effect.Payload) throws(Card.Failure) -> [String]
    }

    var resolver: Resolver {
        switch self {
        case .played: Played()
        case .allInHand: AllInHand()
        case .allInPlay: AllInPlay()
        case .weaponInPlay: WeaponInPlay()
        }
    }

    struct AllInPlay: Resolver {
        func resolve(_ state: GameFeature.State, ctx: Card.Effect.Payload) throws(Card.Failure) -> [String] {
            state.players.get(ctx.target!).inPlay
        }
    }

    struct AllInHand: Resolver {
        func resolve(_ state: GameFeature.State, ctx: Card.Effect.Payload) throws(Card.Failure) -> [String] {
            state.players.get(ctx.target!).hand
        }
    }

    struct Played: Resolver {
        func resolve(_ state: GameFeature.State, ctx: Card.Effect.Payload) throws(Card.Failure) -> [String] {
            [ctx.played]
        }
    }

    struct WeaponInPlay: Resolver {
        func resolve(_ state: GameFeature.State, ctx: Card.Effect.Payload) throws(Card.Failure) -> [String] {
            state.players.get(ctx.target!).inPlay.filter { state.isWeapon($0) }
        }
    }
}

private extension GameFeature.State {
    func isWeapon(_ card: String) -> Bool {
        let cardName = Card.extractName(from: card)
        let cardObj = cards.get(cardName)
        return cardObj.onActive.contains { $0.name == .setWeapon }
    }
}
