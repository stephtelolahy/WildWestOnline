//
//  SelectorResolver.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 25/09/2024.
//

extension TriggeredAbility.Selector {
    func resolve(state: GameState, ctx: ResolvingEffect) throws -> [ResolvingEffect] {
        try resolver.resolve(state: state, ctx: ctx)
    }
}

private extension TriggeredAbility.Selector {
    protocol Resolver {
        func resolve(state: GameState, ctx: ResolvingEffect) throws -> [ResolvingEffect]
    }

    var resolver: Resolver {
        switch self {
        case .setTarget(let target):
            SetTargetResolver(target: target)
        case .setCard(let card):
            fatalError()
        case .setAttribute(let actionAttribute, let value):
            fatalError()
        case .chooseTarget(let conditions):
            ChooseTargetResolver(conditions:  conditions)
        case .chooseCard(let cardCondition):
            fatalError()
        case .chooseCostHandCard(let cardCondition, let count):
            fatalError()
        case .chooseEventuallyCounterHandCard(let cardCondition, let count):
            fatalError()
        case .chooseEventuallyReverseHandCard(let cardCondition):
            fatalError()
        case .repeat(let times):
            RepeatResolver(times: times)
        case .verify(let stateCondition):
            VerifyResolver(stateCondition: stateCondition)
        }
    }

    struct RepeatResolver: Resolver {
        let times: TriggeredAbility.Selector.Number

        func resolve(state: GameState, ctx: ResolvingEffect) throws -> [ResolvingEffect] {
            let number = try times.resolve(state: state, ctx: ctx)
            return Array(repeating: ctx, count: number)
        }
    }

    struct VerifyResolver: Resolver {
        let stateCondition: TriggeredAbility.Selector.StateCondition

        func resolve(state: GameState, ctx: ResolvingEffect) throws -> [ResolvingEffect] {
            try stateCondition.resolve(state: state)
            return [ctx]
        }
    }

    struct SetTargetResolver: Resolver {
        let target: TriggeredAbility.Selector.Target

        func resolve(state: GameState, ctx: ResolvingEffect) throws -> [ResolvingEffect] {
            let targets = try target.resolve(state: state, ctx: ctx)
            return targets.map { aTarget in
                var copy = ctx
                copy.target = aTarget
                return copy
            }
        }
    }

    struct ChooseTargetResolver: Resolver {
        let conditions: [TargetCondition]

        func resolve(state: GameState, ctx: ResolvingEffect) throws -> [ResolvingEffect] {
            let targets = state.playOrder
                .starting(with: ctx.actor)
            fatalError()
        }
    }
}

private extension TriggeredAbility.Selector.TargetCondition {
    func resolve(state: GameState, ctx: ResolvingEffect) throws -> [String] {
        fatalError()
    }
}
