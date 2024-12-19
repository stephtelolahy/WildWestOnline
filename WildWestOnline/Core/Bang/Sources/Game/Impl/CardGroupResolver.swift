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
            [ctx.source]
        }
    }
}
