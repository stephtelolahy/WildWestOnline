//
//  PlayerGroupResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//
extension Card.Selector.PlayerGroup {
    func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String] {
        let players = state.playOrder.starting(with: pendingAction.sourcePlayer)
        switch self {
        case .wounded:
            return players.filter { state.players.get($0).isWounded }

        case .all:
            return players

        case .others(let conditions):
            return players
                .dropFirst()
                .filter { conditions.match($0, pendingAction: pendingAction, state: state) }
        }
    }
}
