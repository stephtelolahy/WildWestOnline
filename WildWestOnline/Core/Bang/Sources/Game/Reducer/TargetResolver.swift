//
//  TargetResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

extension ActionSelector.Target {
    func resolve(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> [String] {
        try resolver.resolve(state, ctx: ctx)
    }
}

private extension ActionSelector.Target {
    protocol Resolver {
        func resolve(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> [String]
    }

    var resolver: Resolver {
        switch self {
        case .damaged: Damaged()
        }
    }

    struct Damaged: Resolver {
        func resolve(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> [String] {
            state.playOrder
                .starting(with: ctx.actor)
                .filter { state.players.get($0).isDamaged }
        }
    }
}

private extension Player {
    var isDamaged: Bool {
        health < maxHealth
    }
}
