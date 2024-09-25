//
//  NumberResolver.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 25/09/2024.
//

extension Effect.Selector.Number {
    func resolve(state: GameState, ctx: ResolvingEffect) throws -> Int {
        try resolver.resolve(state: state, ctx: ctx)
    }
}

private protocol NumberResolver {
    func resolve(state: GameState, ctx: ResolvingEffect) throws -> Int
}

private extension Effect.Selector.Number {
    var resolver: NumberResolver {
        switch self {
        case .activePlayers: NumActivePlayers()
        case .excessHand: NumExcessHand()
        case .wound: NumWound()
        case .damage: NumDamage()
        case .value(let number): NumExact(number: number)
        }
    }
}

struct NumExact: NumberResolver {
    let number: Int

    func resolve(state: GameState, ctx: ResolvingEffect) throws -> Int {
        number
    }
}

struct NumActivePlayers: NumberResolver {
    func resolve(state: GameState, ctx: ResolvingEffect) throws -> Int {
        state.round.playOrder.count
    }
}

struct NumExcessHand: NumberResolver {
    func resolve(state: GameState, ctx: ResolvingEffect) throws -> Int {
        let handCount = state.field.hand.get(ctx.actor).count
        let handlLimit = state.player(ctx.actor).handLimitAtEndOfTurn
        return max(handCount - handlLimit, 0)
    }
}

struct NumWound: NumberResolver {
    func resolve(state: GameState, ctx: ResolvingEffect) throws -> Int {
        let maxHealth = state.player(ctx.actor).attributes.get(.maxHealth)
        let health = state.player(ctx.actor).health
        return maxHealth - health
    }
}

struct NumDamage: NumberResolver {
    func resolve(state: GameState, ctx: ResolvingEffect) throws -> Int {
        guard case let .damage(amount, player) = ctx.event, player == ctx.actor else {
            fatalError("unexpected")
        }

        return amount
    }
}

private extension Player {
    var handLimitAtEndOfTurn: Int {
        attributes[.handLimit] ?? health
    }
}
