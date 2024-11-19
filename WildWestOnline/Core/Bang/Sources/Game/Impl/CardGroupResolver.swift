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
        case .all: All()
        }
    }

    struct All: Resolver {
        func resolve(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> [String] {
            let playerObj = state.players.get(ctx.target)
            return playerObj.inPlay + playerObj.hand
        }
    }
}
