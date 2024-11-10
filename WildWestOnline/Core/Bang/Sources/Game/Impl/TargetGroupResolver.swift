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
        case .active: Active()
        case .others: Others()
        case .next: Next()
        }
    }

    struct Damaged: Resolver {
        func resolve(_ state: GameState, ctx: GameAction.Payload) -> [String] {
            state.playOrder
                .starting(with: ctx.target)
                .filter { state.players.get($0).isDamaged }
        }
    }

    struct Active: Resolver {
        func resolve(_ state: GameState, ctx: GameAction.Payload) -> [String] {
            state.playOrder
                .starting(with: ctx.target)
        }
    }

    struct Others: Resolver {
        func resolve(_ state: GameState, ctx: GameAction.Payload) -> [String] {
            state.playOrder
                .starting(with: ctx.target)
                .filter { $0 != ctx.target }
        }
    }

    struct Next: Resolver {
        func resolve(_ state: GameState, ctx: GameAction.Payload) -> [String] {
            fatalError()
        }
    }
}

private extension Player {
    var isDamaged: Bool {
        health < maxHealth
    }
}
