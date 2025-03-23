//
//  TargetGroupResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

extension Card.Selector.TargetGroup {
    func resolve(_ state: GameState, ctx: GameAction.Payload) throws(GameError) -> [String] {
        let players = resolver.resolve(state, ctx: ctx)
        guard players.isNotEmpty else {
            throw .noTarget(self)
        }

        return players
    }
}

private extension Card.Selector.TargetGroup {
    protocol Resolver {
        func resolve(_ state: GameState, ctx: GameAction.Payload) -> [String]
    }

    var resolver: Resolver {
        switch self {
        case .damaged: Damaged()
        case .active: Active()
        case .others: Others()
        case .next: Next()
        }
    }

    struct Damaged: Resolver {
        func resolve(_ state: GameState, ctx: GameAction.Payload) -> [String] {
            state.playOrder
                .starting(with: ctx.actor)
                .filter { state.players.get($0).isDamaged }
        }
    }

    struct Active: Resolver {
        func resolve(_ state: GameState, ctx: GameAction.Payload) -> [String] {
            state.playOrder
                .starting(with: ctx.actor)
        }
    }

    struct Others: Resolver {
        func resolve(_ state: GameState, ctx: GameAction.Payload) -> [String] {
            state.playOrder
                .starting(with: ctx.actor)
                .filter { $0 != ctx.target }
        }
    }

    struct Next: Resolver {
        func resolve(_ state: GameState, ctx: GameAction.Payload) -> [String] {
            let current = ctx.actor
            let next = state.startOrder
                .filter { state.playOrder.contains($0) || $0 == current }
                .starting(with: current)[1]
            return [next]
        }
    }
}

private extension Player {
    var isDamaged: Bool {
        health < maxHealth
    }
}
