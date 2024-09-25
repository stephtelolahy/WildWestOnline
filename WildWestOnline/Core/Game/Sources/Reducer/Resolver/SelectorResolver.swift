//
//  SelectorResolver.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 25/09/2024.
//

protocol SelectorResolver {
    func resolve(state: GameState, ctx: ResolvingEffect) throws -> [ResolvingEffect]
}

extension TriggeredAbility.Selector {
    func resolve(state: GameState, ctx: ResolvingEffect) throws -> [ResolvingEffect] {
        try resolver.resolve(state: state, ctx: ctx)
    }

    private var resolver: SelectorResolver {
        switch self {
        case .setTarget(let target):
            fatalError()
        case .setCard(let card):
            fatalError()
        case .setAttribute(let actionAttribute, let value):
            fatalError()
        case .chooseTarget(let array):
            fatalError()
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
}

struct RepeatResolver: SelectorResolver {
    let times: TriggeredAbility.Selector.Number

    func resolve(state: GameState, ctx: ResolvingEffect) throws -> [ResolvingEffect] {
        let number = try times.resolve(state: state, ctx: ctx)
        return Array(repeating: ctx, count: number)
    }
}

struct VerifyResolver: SelectorResolver {
    let stateCondition: TriggeredAbility.Selector.StateCondition

    func resolve(state: GameState, ctx: ResolvingEffect) throws -> [ResolvingEffect] {
        try stateCondition.resolve(state: state)
        return [ctx]
    }
}
