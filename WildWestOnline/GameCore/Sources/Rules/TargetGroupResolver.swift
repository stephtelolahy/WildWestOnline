//
//  TargetGroupResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

extension Card.Selector.TargetGroup {
    func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> [String] {
        try resolver.resolve(pendingAction, state: state)
    }
}

private extension Card.Selector.TargetGroup {
    protocol Resolver {
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> [String]
    }

    var resolver: Resolver {
        switch self {
        case .woundedPlayers: WoundedPlayers()
        case .activePlayers: ActivePlayers()
        case .otherPlayers: OtherPlayers()
        case .nextPlayer: NextPlayer()
        case .currentPlayer: CurrentPlayer()
        case .damagingPlayer: DamagingPlayer()
        }
    }

    struct WoundedPlayers: Resolver {
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> [String] {
            let players = state.playOrder
                .starting(with: pendingAction.player)
                .filter { state.players.get($0).isWounded }

            guard players.isNotEmpty else {
                throw .noTarget(.woundedPlayers)
            }

            return players
        }
    }

    struct ActivePlayers: Resolver {
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> [String] {
            state.playOrder
                .starting(with: pendingAction.player)
        }
    }

    struct OtherPlayers: Resolver {
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> [String] {
            Array(state.playOrder.starting(with: pendingAction.player).dropFirst())
        }
    }

    struct NextPlayer: Resolver {
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> [String] {
            let current = pendingAction.player
            let next = state.startOrder
                .filter { state.playOrder.contains($0) || $0 == current }
                .starting(with: current)[1]
            return [next]
        }
    }

    struct CurrentPlayer: Resolver {
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> [String] {
            [pendingAction.player]
        }
    }

    struct DamagingPlayer: Resolver {
        func resolve(_ pendingAction: Card.Effect, state: GameFeature.State) throws(Card.PlayError) -> [String] {
            guard let parentAction = pendingAction.triggeredBy?.first,
                  parentAction.name == .damage else {
                fatalError("Expected trigger from damage")
            }

            if parentAction.player == parentAction.targetedPlayer {
                return []
            } else {
                assert(state.players[parentAction.player] != nil)
                return [parentAction.player]
            }
        }
    }
}

private extension GameFeature.State.Player {
    var isWounded: Bool {
        health < maxHealth
    }
}
