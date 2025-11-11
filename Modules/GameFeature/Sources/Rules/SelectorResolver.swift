//
//  SelectorResolver.swift
//
//  Created by Hugues Telolahy on 30/10/2024.
//

extension Card.Selector {
    func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
        try resolver.resolve(pendingAction, state: state)
    }
}

private extension Card.Selector {
    protocol Resolver {
        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action]
    }

    var resolver: Resolver {
        switch self {
        case .repeat(let count): Repeat(count: count)
        case .setTarget(let target): SetTarget(targetGroup: target)
        case .setCard(let card): SetCard(cardGroup: card)
        case .chooseOne(let element, let prompt, let selection): ChooseOne(requirement: element, prompt: prompt, selection: selection)
        case .require(let requirement): Require(requirement: requirement)
        case .applyIf(let requirement): ApplyIf(requirement: requirement)
        }
    }

    struct Repeat: Resolver {
        let count: Card.Selector.RepeatCount

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
            let value = count.resolve(pendingAction, state: state)
            return Array(repeating: pendingAction, count: value)
        }
    }

    struct SetTarget: Resolver {
        let targetGroup: Card.Selector.PlayerGroup

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
            let targets = targetGroup.resolve(pendingAction, state: state)
            guard targets.isNotEmpty else {
                throw .noTarget(targetGroup)
            }

            return targets.map { pendingAction.withTarget($0) }
        }
    }

    struct SetCard: Resolver {
        let cardGroup: Card.Selector.CardGroup

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
            cardGroup.resolve(pendingAction, state: state)
                .map { pendingAction.withCard($0) }
        }
    }

    struct ChooseOne: Resolver {
        let requirement: ChoiceRequirement
        let prompt: ChoicePrompt?
        let selection: String?

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
            guard let prompt else {
                return try requirement.resolveOptions(pendingAction, state: state)
            }

            guard let selection,
                  let selectionValue = prompt.options.first(where: { $0.label == selection })?.id else {
                fatalError("Selection \(String(describing: selection)) not found in options")
            }

            return requirement.resolveSelection(selectionValue, pendingAction: pendingAction, state: state)
        }
    }

    struct Require: Resolver {
        let requirement: Card.Selector.PlayRequirement

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
            guard requirement.match(pendingAction, state: state) else {
                throw .noReq(requirement)
            }

            return [pendingAction]
        }
    }

    struct ApplyIf: Resolver {
        let requirement: Card.Selector.PlayRequirement

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
            guard requirement.match(pendingAction, state: state) else {
                return []
            }

            return [pendingAction]
        }
    }
}

extension GameFeature.Action {
    func withTarget(_ target: String) -> Self {
        var copy = self
        copy.targetedPlayer = target
        return copy
    }

    func withCard(_ card: String) -> Self {
        var copy = self
        copy.targetedCard = card
        return copy
    }
}
