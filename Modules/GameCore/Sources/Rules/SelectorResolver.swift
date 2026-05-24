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
        case .target(let identity): Target(identity: identity)
        case .card(let identity): CardResolver(identity: identity)
        case .choose(let choice, let status): Choose(choice: choice, status: status)
        case .require(let requirement): Require(requirement: requirement)
        case .applyIf(let requirement): ApplyIf(requirement: requirement)
        case .amount(let amount): Amount(amount: amount)
        }
    }

    struct Repeat: Resolver {
        let count: Card.Selector.RepeatCount

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
            let value = count.resolve(pendingAction, state: state)
            return Array(repeating: pendingAction, count: value)
        }
    }

    struct Target: Resolver {
        let identity: Card.Selector.PlayerTarget

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
            guard let targets = identity.resolve(pendingAction, state: state) else {
                throw .noPlayer(identity)
            }

            return targets.map { pendingAction.copy(targetedPlayer: $0) }
        }
    }

    struct CardResolver: Resolver {
        let identity: Card.Selector.CardTarget

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
            guard let cards = identity.resolve(pendingAction, state: state) else {
                return [] // silently skip effect if cannot set card
            }

            return cards.map { pendingAction.copy(targetedCard: $0, state: state) }
        }
    }

    struct Choose: Resolver {
        let choice: ChoiceKind
        let status: ChoiceStatus

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
            try choice.resolve(status: status, pendingAction: pendingAction, state: state)
        }
    }

    struct Require: Resolver {
        let requirement: Card.Selector.Requirement

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
            guard requirement.match(pendingAction, state: state) else {
                throw .noReq(requirement)
            }

            return [pendingAction]
        }
    }

    struct ApplyIf: Resolver {
        let requirement: Card.Selector.Requirement

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
            guard requirement.match(pendingAction, state: state) else {
                return []
            }

            return [pendingAction]
        }
    }

    struct Amount: Resolver {
        let amount: Int

        func resolve(_ pendingAction: GameFeature.Action, state: GameFeature.State) throws(GameFeature.Error) -> [GameFeature.Action] {
            var copy = pendingAction
            copy.amount = amount
            return [copy]
        }
    }
}
