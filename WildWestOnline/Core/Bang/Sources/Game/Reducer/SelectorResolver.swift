//
//  SelectorResolver.swift
//  Bang
//
//  Created by Hugues Telolahy on 30/10/2024.
//

extension ActionSelector {
    func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction] {
        try resolver.resolve(pendingAction, state)
    }
}

private extension ActionSelector {
    protocol Resolver {
        func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction]
    }

    var resolver: Resolver {
        switch self {
        case .repeat(let number): Repeat(number: number)
        case .setAmount(let number): SetAmount(number: number)
        case .setTarget(let target): SetTarget(target: target)
        }
    }

    struct Repeat: Resolver {
        let number: ActionSelector.Number

        func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction] {
            let value = try number.resolve(state)
            return Array(repeating: pendingAction, count: value)
        }
    }

    struct SetAmount: Resolver {
        let number: ActionSelector.Number

        func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction] {
            var pendingAction = pendingAction
            let value = try number.resolve(state)
            pendingAction.payload.amount = value
            return [pendingAction]
        }
    }

    struct SetTarget: Resolver {
        let target: ActionSelector.Target

        func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction] {
            try target.resolve(state, ctx: pendingAction.payload)
                .map { pendingAction.withTarget($0) }
        }
    }
}

private extension GameAction {
    func withTarget(_ target: String) -> Self {
        var copy = self
        copy.payload.actor = target
        return copy
    }
}
