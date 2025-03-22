//
//  CardGroupResolver.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 19/11/2024.
//

extension Card.Selector.CardGroup {
    func resolve(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> [String] {
        try resolver.resolve(state, ctx: ctx)
    }
}

private extension Card.Selector.CardGroup {
    protocol Resolver {
        func resolve(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> [String]
    }

    var resolver: Resolver {
        switch self {
        case .played: Played()
        case .allHand: AllHand()
        case .allInPlay: AllInPlay()
        case .equipedWeapon: EquipedWeapon()
        }
    }

    struct AllInPlay: Resolver {
        func resolve(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> [String] {
            state.players.get(ctx.target).inPlay
        }
    }

    struct AllHand: Resolver {
        func resolve(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> [String] {
            state.players.get(ctx.target).hand
        }
    }

    struct Played: Resolver {
        func resolve(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> [String] {
            [ctx.played]
        }
    }

    struct EquipedWeapon: Resolver {
        func resolve(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> [String] {
            state.players.get(ctx.target).inPlay.filter { state.isWeapon($0) }
        }
    }
}

private extension GameState {
    func isWeapon(_ card: String) -> Bool {
        let cardName = Card.extractName(from: card)
        let cardObj = cards.get(cardName)
        return cardObj.onActive.contains { $0.name == .setWeapon }
    }
}
