//
//  NumberResolver.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 25/09/2024.
//

protocol NumberResolver {
    func resolve(state: GameState, ctx: ResolvingEffect) throws -> Int
}

extension TriggeredAbility.Selector.Number {
    func resolve(state: GameState, ctx: ResolvingEffect) throws -> Int {
        try resolver.resolve(state: state, ctx: ctx)
    }

    private var resolver: NumberResolver {
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
        state.playOrder.count
    }
}

struct NumExcessHand: NumberResolver {
    func resolve(state: GameState, ctx: ResolvingEffect) throws -> Int {
        let handCount = state.player(ctx.actor).hand.count
        let handlLimit = state.player(ctx.actor).handLimitAtEndOfTurn
        return max(handCount - handlLimit, 0)
    }
}

struct NumWound: NumberResolver {
    func resolve(state: GameState, ctx: ResolvingEffect) throws -> Int {
        let maxHealth = state.player(ctx.actor).maxHealth
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
        handLimit ?? health
    }
}
