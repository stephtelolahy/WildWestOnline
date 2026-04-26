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
        case .forEachTarget(let group): ForEachTarget(group: group)
        case .setTarget(let identity): SetTarget(identity: identity)
        case .forEachCard(let group): ForEachCard(group: group)
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

    struct ForEachTarget: Resolver {
        let group: Card.Selector.PlayerGroup

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
            let targets = group.resolve(pendingAction, state: state)
            guard targets.isNotEmpty else {
                throw .noTarget(group)
            }

            return targets.map { pendingAction.withTargetedPlayer($0) }
        }
    }

    struct SetTarget: Resolver {
        let identity: Card.Selector.PlayerIdentity

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
            guard let target = identity.resolve(pendingAction, state: state) else {
                throw .noPlayer(identity)
            }

            return [pendingAction.withTargetedPlayer(target)]
        }
    }

    struct ForEachCard: Resolver {
        let group: Card.Selector.CardGroup

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
            group.resolve(pendingAction, state: state)
                .map { pendingAction.withTargetedCard($0) }
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

extension GameFeature.Action {
    func withTargetedPlayer(_ target: String) -> Self {
        var copy = self
        copy.targetedPlayer = target
        return copy
    }

    func withTargetedCard(_ card: String) -> Self {
        var copy = self
        copy.targetedCard = card
        return copy
    }
}
