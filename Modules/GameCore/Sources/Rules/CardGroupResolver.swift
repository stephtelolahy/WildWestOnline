//
//  CardGroupResolver.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 19/11/2024.
//
extension Card.Selector.CardGroup {
    func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String] {
        switch self {
        case .all:
            let targetObj = state.players.get(pendingAction.requiredTarget)
            return targetObj.inPlay + targetObj.hand
        }
    }
}
