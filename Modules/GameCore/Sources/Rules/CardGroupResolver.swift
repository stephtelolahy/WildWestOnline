//
//  CardGroupResolver.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 19/11/2024.
//
extension Card.Selector.CardGroup {
    func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String] {
        resolver.resolve(pendingAction, state: state)
    }
}

private extension Card.Selector.CardGroup {
    protocol Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String]
    }

    var resolver: Resolver {
        switch self {
        case .all: All()
        }
    }

    struct All: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String] {
            guard let target = pendingAction.targetedPlayer else { fatalError("Missing targetedPlayer") }
            let targetObj = state.players.get(target)
            return targetObj.inPlay + targetObj.hand
        }
    }
}
