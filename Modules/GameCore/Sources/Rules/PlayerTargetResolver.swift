//
//  PlayerTargetResolver.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 26/04/2026.
//

extension Card.Selector.PlayerTarget {
    func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String]? {
        resolver.resolve(pendingAction, state: state)
    }
}

private extension Card.Selector.PlayerTarget {
    protocol Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String]?
    }

    var resolver: Resolver {
        switch self {
        case .next: Next()
        case .attacker: Attacker()
        case .myself: Myself()
        case .triggerTarget: TriggerTarget()
        case .eliminated: Eliminated()
        case .every(let group): Every(group: group)
        }
    }

    struct Next: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String]? {
            let current = pendingAction.sourcePlayer
            let orderedPlayers = state.startOrder
                .filter { state.playOrder.contains($0) || $0 == current }
                .starting(with: current)
            guard orderedPlayers.count >= 2 else {
                return nil
            }

            return [orderedPlayers[1]]
        }
    }

    struct Attacker: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String]? {
            guard let parentAction = pendingAction.triggeredBy.first,
                  parentAction.name == .damage else {
                fatalError("Expected trigger from damage")
            }

            let damagingPlayer = parentAction.sourcePlayer
            guard damagingPlayer != parentAction.targetedPlayer else {
                return nil
            }

            return [damagingPlayer]
        }
    }

    struct Myself: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String]? {
            [pendingAction.sourcePlayer]
        }
    }

    struct TriggerTarget: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String]? {
            guard let parentAction = pendingAction.triggeredBy.first,
                  let targetedPlayer = parentAction.targetedPlayer else {
                return nil
            }

            return [targetedPlayer]
        }
    }

    struct Eliminated: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String]? {
            guard let parentAction = pendingAction.triggeredBy.first,
                  parentAction.name == .eliminate,
                  let targetedPlayer = parentAction.targetedPlayer else {
                return nil
            }

            return [targetedPlayer]
        }
    }

    struct Every: Resolver {
        let group: Card.Selector.PlayerGroup

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String]? {
            let targets = group.resolve(pendingAction, state: state)
            guard targets.isNotEmpty else {
                return nil
            }

            return targets
        }
    }
}
