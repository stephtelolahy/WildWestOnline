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
        case .target(let identity): SetTarget(identity: identity)
        case .forEachCard(let group): ForEachCard(group: group)
        case .setCard(let identity): SetCard(identity: identity)
        case .chooseOne(let choice, let prompt, let selection): ChooseOne(choice: choice, prompt: prompt, selection: selection)
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
        let identity: Card.Selector.PlayerTarget

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
            guard let targets = identity.resolve(pendingAction, state: state) else {
                throw .noPlayer(identity)
            }

            return targets.map { pendingAction.copy(targetedPlayer: $0) }
        }
    }

    struct ForEachCard: Resolver {
        let group: Card.Selector.CardGroup

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
            group.resolve(pendingAction, state: state)
                .map { pendingAction.copy(targetedCard: $0, state: state) }
        }
    }

    struct SetCard: Resolver {
        let identity: Card.Selector.CardRef

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
            guard let card = identity.resolve(pendingAction, state: state) else {
                return [] // silently skip effect is cannot set card
            }

            return [pendingAction.copy(targetedCard: card, state: state)]
        }
    }

    struct ChooseOne: Resolver {
        let choice: ChoiceKind
        let prompt: ChoicePrompt?
        let selection: String?

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
            guard let prompt else {
                return try choice.resolveOptions(pendingAction, state: state)
            }

            guard let selection,
                  let selectionValue = prompt.options.first(where: { $0.label == selection })?.id else {
                fatalError("Selection \(String(describing: selection)) not found in options")
            }

            return choice.resolveSelection(selectionValue, pendingAction: pendingAction, state: state)
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
