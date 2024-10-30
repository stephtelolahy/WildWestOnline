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
        case .repeat(let number):
            Repeat(number: number)
        case .setAmount(let number):
            SetAmount(number: number)
        }
    }

    struct Repeat: Resolver {
        let number: ActionSelector.Number

        func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction] {
            switch number {
            case .value(let times):
                Array(repeating: pendingAction, count: times)
            }
        }
    }

    struct SetAmount: Resolver {
        let number: Int

        func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction] {
            var pendingAction = pendingAction
            pendingAction.payload.amount = number
            return [pendingAction]
        }
    }
}
