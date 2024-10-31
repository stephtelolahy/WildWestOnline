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
        case .chooseTarget(let conditions): ChooseTarget(conditions: conditions)
        case .chooseCard(let conditions): ChooseCard(conditions: conditions)
        case .verify(let condition): Verify(condition: condition)
        }
    }

    struct Repeat: Resolver {
        let number: ActionSelector.Number

        func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction] {
            let value = number.resolve(state)
            return Array(repeating: pendingAction, count: value)
        }
    }

    struct SetAmount: Resolver {
        let number: ActionSelector.Number

        func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction] {
            var pendingAction = pendingAction
            let value = number.resolve(state)
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

    struct Verify: Resolver {
        let condition: ActionSelector.StateCondition

        func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction] {
            try condition.match(state)
            return [pendingAction]
        }
    }

    struct ChooseTarget: Resolver {
        let conditions: [ActionSelector.TargetCondition]

        func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction] {
            let possibleTargets = state.playOrder.starting(with: pendingAction.payload.actor)
                .filter { player in
                    conditions.allSatisfy { condition in
                        condition.match(player, state: state)
                    }
                }

            guard possibleTargets.isNotEmpty else {
                throw .noChoosableTarget(conditions)
            }

            guard possibleTargets.count == 1 else {
                fatalError("Unimplemented choice")
            }

            let result = pendingAction.withTarget(possibleTargets[0])
            return [result]
        }
    }

    struct ChooseCard: Resolver {
        let conditions: [ActionSelector.CardCondition]

        func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction] {
            let playerObj = state.players.get(pendingAction.payload.actor)
            let possibleCards: [String] = playerObj.hand + playerObj.inPlay
            guard possibleCards.isNotEmpty else {
                fatalError("No matching card")
            }

            guard possibleCards.count == 1 else {
                fatalError("Unimplemented choice")
            }

            var result = pendingAction
            result.payload.card = possibleCards[0]
            return [result]
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
