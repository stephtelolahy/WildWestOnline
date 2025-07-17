//
//  TargetGroupResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

extension Card.Selector.TargetGroup {
    func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> [String] {
        let players = resolver.resolve(pendingAction, state: state)
        guard players.isNotEmpty else {
            throw .noTarget(self)
        }

        return players
    }
}

private extension Card.Selector.TargetGroup {
    protocol Resolver {
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) -> [String]
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
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) -> [String] {
            state.playOrder
                .starting(with: pendingAction.payload.player)
                .filter { state.players.get($0).isWounded }
        }
    }

    struct ActivePlayers: Resolver {
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) -> [String] {
            state.playOrder
                .starting(with: pendingAction.payload.player)
        }
    }

    struct OtherPlayers: Resolver {
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) -> [String] {
            state.playOrder
                .starting(with: pendingAction.payload.player)
                .filter { $0 != pendingAction.payload.targetedPlayer }
        }
    }

    struct NextPlayer: Resolver {
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) -> [String] {
            let current = pendingAction.payload.player
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
