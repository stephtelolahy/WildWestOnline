//
//  TargetGroupResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

extension Card.Selector.TargetGroup {
    func resolve(_ state: GameFeature.State, ctx: Card.Effect.Payload) throws(Card.Failure) -> [String] {
        let players = resolver.resolve(state, ctx: ctx)
        guard players.isNotEmpty else {
            throw .noTarget(self)
        }

        return players
    }
}

private extension Card.Selector.TargetGroup {
    protocol Resolver {
        func resolve(_ state: GameFeature.State, ctx: Card.Effect.Payload) -> [String]
    }

    var resolver: Resolver {
        switch self {
        case .woundedPlayers: WoundedPlayers()
        case .activePlayers: ActivePlayers()
        case .otherPlayers: OtherPlayers()
        case .nextPlayer: NextPlayer()
        }
    }

    struct WoundedPlayers: Resolver {
        func resolve(_ state: GameFeature.State, ctx: Card.Effect.Payload) -> [String] {
            state.playOrder
                .starting(with: ctx.player)
                .filter { state.players.get($0).isWounded }
        }
    }

    struct ActivePlayers: Resolver {
        func resolve(_ state: GameFeature.State, ctx: Card.Effect.Payload) -> [String] {
            state.playOrder
                .starting(with: ctx.player)
        }
    }

    struct OtherPlayers: Resolver {
        func resolve(_ state: GameFeature.State, ctx: Card.Effect.Payload) -> [String] {
            state.playOrder
                .starting(with: ctx.player)
                .filter { $0 != ctx.target }
        }
    }

    struct NextPlayer: Resolver {
        func resolve(_ state: GameFeature.State, ctx: Card.Effect.Payload) -> [String] {
            let current = ctx.player
            let next = state.startOrder
                .filter { state.playOrder.contains($0) || $0 == current }
                .starting(with: current)[1]
            return [next]
        }
    }
}

private extension GameFeature.State.Player {
    var isWounded: Bool {
        health < maxHealth
    }
}
