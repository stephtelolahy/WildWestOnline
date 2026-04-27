//
//  PlayerIdentityResolver.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 26/04/2026.
//

extension Card.Selector.PlayerIdentity {
    func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> String? {
        resolver.resolve(pendingAction, state: state)
    }
}

private extension Card.Selector.PlayerIdentity {
    protocol Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> String?
    }

    var resolver: Resolver {
        switch self {
        case .nextPlayer: NextPlayer()
        case .damagingPlayer: DamagingPlayer()
        case .sourcePlayer: SourcePlayer()
        case .eliminatedPlayer: EliminatedPlayer()
        }
    }

    struct NextPlayer: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> String? {
            let current = pendingAction.sourcePlayer
            let orderedPlayers = state.startOrder
                .filter { state.playOrder.contains($0) || $0 == current }
                .starting(with: current)
            guard orderedPlayers.count >= 2 else {
                return nil
            }

            return orderedPlayers[1]
        }
    }

    struct DamagingPlayer: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> String? {
            guard let parentAction = pendingAction.triggeredBy.first,
                  parentAction.name == .damage else {
                fatalError("Expected trigger from damage")
            }

            let damagingPlayer = parentAction.sourcePlayer
            guard damagingPlayer != parentAction.targetedPlayer else {
                return nil
            }

            return damagingPlayer
        }
    }

    struct SourcePlayer: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> String? {
            pendingAction.sourcePlayer
        }
    }

    struct EliminatedPlayer: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> String? {
            guard let parentAction = pendingAction.triggeredBy.first,
                  parentAction.name == .eliminate,
                  let targetedPlayer = parentAction.targetedPlayer else {
                fatalError("Expected trigger from eliminate")
            }

            return targetedPlayer
        }
    }
}
