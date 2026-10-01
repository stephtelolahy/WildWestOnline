//
//  PlayerTargetResolver.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 26/04/2026.
//

extension Card.Selector.PlayerTarget {
    func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String]? {
        let current = pendingAction.sourcePlayer
        let parentAction = pendingAction.triggeredBy.first
        switch self {
        case .next:
            let orderedPlayers = state.startOrder
                .filter { state.playOrder.contains($0) || $0 == current }
                .starting(with: current)
            return orderedPlayers.count >= 2 ? [orderedPlayers[1]] : nil

        case .attacker:
            guard let parentAction, parentAction.name == .damage else {
                fatalError("Expected trigger from damage")
            }

            let damagingPlayer = parentAction.sourcePlayer
            return damagingPlayer != parentAction.targetedPlayer ? [damagingPlayer] : nil

        case .myself:
            return [current]

        case .trigger:
            return parentAction?.targetedPlayer.map { [$0] }

        case .every(let group):
            let targets = group.resolve(pendingAction, state: state)
            return targets.isNotEmpty ? targets : nil
        }
    }
}
