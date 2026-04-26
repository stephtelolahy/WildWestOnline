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
        case .allInHand: AllInHand()
        case .allInPlay: AllInPlay()
        }
    }

    struct AllInPlay: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String] {
            guard let target = pendingAction.targetedPlayer else { fatalError("Missing targetedPlayer") }

            return state.players.get(target).inPlay
        }
    }

    struct AllInHand: Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) -> [String] {
            guard let target = pendingAction.targetedPlayer else { fatalError("Missing targetedPlayer") }

            return state.players.get(target).hand
        }
    }
}
