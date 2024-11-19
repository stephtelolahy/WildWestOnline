//
//  SelectorResolver.swift
//  Bang
//
//  Created by Hugues Telolahy on 30/10/2024.
//

extension Card.Selector {
    func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction] {
        try resolver.resolve(pendingAction, state)
    }
}

private extension Card.Selector {
    protocol Resolver {
        func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction]
    }

    var resolver: Resolver {
        switch self {
        case .repeat(let number): Repeat(number: number)
        case .setAmount(let number): SetAmount(number: number)
        case .setTarget(let target): SetTarget(targetGroup: target)
        case .setCard(let card): SetCard(cardGroup: card)
        case .chooseOne(let element, let resolved, let selection): ChooseOne(element: element, resolved: resolved, selection: selection)
        }
    }

    struct Repeat: Resolver {
        let number: Card.Selector.Number

        func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction] {
            let value = number.resolve(actor: pendingAction.payload.actor, state: state)
            return Array(repeating: pendingAction, count: value)
        }
    }

    struct SetAmount: Resolver {
        let number: Int

        func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction] {
            [pendingAction.withAmount(number)]
        }
    }

    struct SetTarget: Resolver {
        let targetGroup: Card.Selector.TargetGroup

        func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction] {
            try targetGroup.resolve(state, ctx: pendingAction.payload)
                .map { pendingAction.withTarget($0) }
        }
    }

    struct SetCard: Resolver {
        let cardGroup: Card.Selector.CardGroup

        func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction] {
            try cardGroup.resolve(state, ctx: pendingAction.payload)
                .map { pendingAction.withCard($0) }
        }
    }

    struct ChooseOne: Resolver {
        let element: ChooseOneElement
        let resolved: ChooseOneResolved?
        let selection: String?

        func resolve(_ pendingAction: GameAction, _ state: GameState) throws(GameError) -> [GameAction] {
            if let resolved {
                // handle choice
                guard let selection else {
                    fatalError("Unexpected, waiting user choice")
                }

                guard let selectionValue = resolved.options.first(where: { $0.label == selection })?.value else {
                    fatalError("Selection \(selection) not found in options")
                }

                return try element.resolveSelection(selectionValue, state: state, pendingAction: pendingAction)
            } else {
                // generate options
                guard let choice = try element.resolveOptions(state, ctx: pendingAction.payload) else {
                    return [pendingAction]
                }

                var updatedAction = pendingAction
                let updatedSelector = Card.Selector.chooseOne(element, resolved: choice)
                updatedAction.payload.selectors.insert(updatedSelector, at: 0)
                return [updatedAction]
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
