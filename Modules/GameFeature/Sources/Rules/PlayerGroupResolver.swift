//
//  PlayerGroupResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

extension Card.Selector.PlayerGroup {
    func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [String] {
        try resolver.resolve(pendingAction, state: state)
    }
}

private extension Card.Selector.PlayerGroup {
    protocol Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [String]
    }

    var resolver: Resolver {
        switch self {
        case .woundedPlayers: WoundedPlayers()
        case .activePlayers: ActivePlayers()
        case .otherPlayers: OtherPlayers()
        case .nextPlayer: NextPlayer()
        case .damagingPlayer: DamagingPlayer()
        case .currentPlayer: CurrentPlayer()
        }
    }

    struct WoundedPlayers: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [String] {
            let players = state.playOrder
                .starting(with: pendingAction.sourcePlayer)
                .filter { state.players.get($0).isWounded }

            guard players.isNotEmpty else {
                throw .noTarget(.woundedPlayers)
            }

            return players
        }
    }

    struct ActivePlayers: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [String] {
            state.playOrder
                .starting(with: pendingAction.sourcePlayer)
        }
    }

    struct OtherPlayers: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [String] {
            Array(state.playOrder.starting(with: pendingAction.sourcePlayer).dropFirst())
        }
    }

    struct NextPlayer: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [String] {
            let current = pendingAction.sourcePlayer
            let next = state.startOrder
                .filter { state.playOrder.contains($0) || $0 == current }
                .starting(with: current)[1]
            return [next]
        }
    }

    struct DamagingPlayer: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [String] {
            guard let parentAction = pendingAction.triggeredBy.first,
                  parentAction.name == .damage else {
                fatalError("Expected trigger from damage")
            }

            guard parentAction.sourcePlayer != parentAction.targetedPlayer else {
                return []
            }

            return [parentAction.sourcePlayer]
        }
    }

    struct CurrentPlayer: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(Card.PlayError) -> [String] {
            [pendingAction.sourcePlayer]
        }
    }
}

private extension GameFeature.State.Player {
    var isWounded: Bool {
        health < maxHealth
    }
}
