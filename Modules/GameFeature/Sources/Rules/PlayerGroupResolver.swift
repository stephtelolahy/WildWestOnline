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
        case .nextPlayer: NextPlayer()
        case .damagingPlayer: DamagingPlayer()
        case .sourcePlayer: SourcePlayer()
        case .eliminatedPlayer: EliminatedPlayer()
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

    struct NextPlayer: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String] {
            let current = pendingAction.sourcePlayer
            let orderedPlayers = state.startOrder
                .filter { state.playOrder.contains($0) || $0 == current }
                .starting(with: current)
            guard orderedPlayers.count >= 2 else {
                return []
            }

            let next = orderedPlayers[1]
            return [next]
        }
    }

    struct DamagingPlayer: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String] {
            guard let parentAction = pendingAction.triggeredBy.first,
                  parentAction.name == .damage else {
                fatalError("Expected trigger from damage")
            }

            let damagingPlayer = parentAction.sourcePlayer
            guard damagingPlayer != parentAction.targetedPlayer else {
                return []
            }

            return [damagingPlayer]
        }
    }

    struct SourcePlayer: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String] {
            [pendingAction.sourcePlayer]
        }
    }

    struct EliminatedPlayer: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String] {
            guard let parentAction = pendingAction.triggeredBy.first,
                  parentAction.name == .eliminate,
                    let targetedPlayer = parentAction.targetedPlayer else {
                fatalError("Expected trigger from eliminate")
            }

            return [targetedPlayer]
        }
    }
}
