//
//  PlayerGroupResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//
extension Card.Selector.PlayerGroup {
    func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String] {
        resolver.resolve(pendingAction, state: state)
    }
}

private extension Card.Selector.PlayerGroup {
    protocol Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String]
    }

    var resolver: Resolver {
        switch self {
        case .woundedPlayers: WoundedPlayers()
        case .activePlayers: ActivePlayers()
        case .otherPlayers(let conditions): OtherPlayers(conditions: conditions)
        }
    }

    struct WoundedPlayers: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String] {
            state.playOrder
                .starting(with: pendingAction.sourcePlayer)
                .filter { state.players.get($0).isWounded }
        }
    }

    struct ActivePlayers: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String] {
            state.playOrder
                .starting(with: pendingAction.sourcePlayer)
        }
    }

    struct OtherPlayers: Resolver {
        let conditions: [Card.Selector.PlayerFilter]

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String] {
            let targetPlayers = state.playOrder
                .starting(with: pendingAction.sourcePlayer)
                .dropFirst()
                .filter { conditions.match($0, pendingAction: pendingAction, state: state) }

            return Array(targetPlayers)
        }
    }
}
