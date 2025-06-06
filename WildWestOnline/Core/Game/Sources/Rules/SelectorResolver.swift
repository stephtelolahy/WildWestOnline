//
//  SelectorResolver.swift
//
//  Created by Hugues Telolahy on 30/10/2024.
//

extension Card.Selector {
    func resolve(_ pendingAction: Card.Effect, _ state: GameFeature.State) throws(Card.Failure) -> [Card.Effect] {
        try resolver.resolve(pendingAction, state)
    }
}

private extension Card.Selector {
    protocol Resolver {
        func resolve(_ pendingAction: Card.Effect, _ state: GameFeature.State) throws(Card.Failure) -> [Card.Effect]
    }

    var resolver: Resolver {
        switch self {
        case .repeat(let number): Repeat(number: number)
        case .setTarget(let target): SetTarget(targetGroup: target)
        case .setCard(let card): SetCard(cardGroup: card)
        case .chooseOne(let element, let resolved, let selection): ChooseOne(element: element, resolved: resolved, selection: selection)
        case .require(let stateReq): Require(stateReq: stateReq)
        }
    }

    struct Repeat: Resolver {
        let number: Card.Selector.Number

        func resolve(_ pendingAction: Card.Effect, _ state: GameFeature.State) throws(Card.Failure) -> [Card.Effect] {
            let value = number.resolve(player: pendingAction.payload.player, state: state)
            return Array(repeating: pendingAction, count: value)
        }
    }

    struct SetTarget: Resolver {
        let targetGroup: Card.Selector.TargetGroup

        func resolve(_ pendingAction: Card.Effect, _ state: GameFeature.State) throws(Card.Failure) -> [Card.Effect] {
            try targetGroup.resolve(state, ctx: pendingAction.payload)
                .map { pendingAction.withTarget($0) }
        }
    }

    struct SetCard: Resolver {
        let cardGroup: Card.Selector.CardGroup

        func resolve(_ pendingAction: Card.Effect, _ state: GameFeature.State) throws(Card.Failure) -> [Card.Effect] {
            try cardGroup.resolve(state, ctx: pendingAction.payload)
                .map { pendingAction.withCard($0) }
        }
    }

    struct ChooseOne: Resolver {
        let element: ChooseOneElement
        let resolved: ChooseOneResolved?
        let selection: String?

        func resolve(_ pendingAction: Card.Effect, _ state: GameFeature.State) throws(Card.Failure) -> [Card.Effect] {
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
                updatedAction.selectors.insert(updatedSelector, at: 0)
                return [updatedAction]
            }
        }
    }

    struct Require: Resolver {
        let stateReq: Card.StateReq

        func resolve(_ pendingAction: Card.Effect, _ state: GameFeature.State) throws(Card.Failure) -> [Card.Effect] {
            guard stateReq.match(pendingAction.payload, state: state) else {
                return []
            }

            return [pendingAction]
        }
    }
}

extension Card.Effect {
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
}
