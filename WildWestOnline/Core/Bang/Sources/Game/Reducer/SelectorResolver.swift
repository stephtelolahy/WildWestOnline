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
        case .verify(let condition): Verify(condition: condition)
        case .chooseOne(let details): ChooseOne(details: details)
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
            let amount = number.resolve(state)
            return [pendingAction.withAmount(amount)]
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

    struct ChooseOne: Resolver {
        let details: ChooseOneDetails

        func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction] {
            if details.options.isEmpty {
                var updatedAction = pendingAction
                var updatedDetails = details
                updatedDetails.options = try details.element.resolveOptions(state, ctx: pendingAction.payload)
                let updatedSelector = ActionSelector.chooseOne(updatedDetails)
                updatedAction.payload.selectors.insert(updatedSelector, at: 0)
                return [updatedAction]
            } else if let selectionLabel = details.selection {
                guard let selectionValue = details.options.first(where: { $0.label == selectionLabel })?.value else {
                    fatalError("Selection \(selectionLabel) not found in options")
                }

                return try details.element.resolveSelection(selectionValue, state: state, pendingAction: pendingAction)
            } else {
                fatalError("Unexpected, waiting user choice")
            }
        }
    }
}

extension GameAction {
    func withTarget(_ target: String) -> Self {
        var copy = self
        copy.payload.target = target
        return copy
    }

    func withCard(_ card: String) -> Self {
        var copy = self
        copy.payload.card = card
        return copy
    }

    func withAmount(_ amount: Int) -> Self {
        var copy = self
        copy.payload.amount = amount
        return copy
    }
}
