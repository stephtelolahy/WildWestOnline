//
//  TargetGroupResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

extension ActionSelector.TargetGroup {
    func resolve(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> [String] {
        let players = resolver.resolve(state, ctx: ctx)
        guard players.isNotEmpty else {
            throw .noTarget(self)
        }

        return players
    }
}

private extension ActionSelector.TargetGroup {
    protocol Resolver {
        func resolve(_ state: GameState, ctx: GameAction.Payload) -> [String]
    }

    var resolver: Resolver {
        switch self {
        case .damaged: Damaged()
        }
    }

    struct Damaged: Resolver {
        func resolve(_ state: GameState, ctx: GameAction.Payload) -> [String] {
            state.playOrder
                .starting(with: ctx.target)
                .filter { state.players.get($0).isDamaged }
        }
    }
}

private extension Player {
    var isDamaged: Bool {
        health < maxHealth
    }
}
