//
//  Resolver.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 25/09/2024.
//

extension TriggeredAbility.Selector.Number {
    func resolve(state: GameState, ctx: PendingAction) throws -> Int {
        try resolver.resolve(state: state, ctx: ctx)
    }
}

private extension TriggeredAbility.Selector.Number {
    protocol Resolver {
        func resolve(state: GameState, ctx: PendingAction) throws -> Int
    }

    var resolver: Resolver {
        switch self {
        case .activePlayers: NumActivePlayers()
        case .excessHand: NumExcessHand()
        case .wound: NumWound()
        case .damage: NumDamage()
        case .value(let number): NumExact(number: number)
        }
    }

    struct NumExact: Resolver {
        let number: Int

        func resolve(state: GameState, ctx: PendingAction) throws -> Int {
            number
        }
    }

    struct NumActivePlayers: Resolver {
        func resolve(state: GameState, ctx: PendingAction) throws -> Int {
            state.playOrder.count
        }
    }

    struct NumExcessHand: Resolver {
        func resolve(state: GameState, ctx: PendingAction) throws -> Int {
            let handCount = state.player(ctx.actor).hand.count
            let handlLimit = state.player(ctx.actor).handLimitAtEndOfTurn
            return max(handCount - handlLimit, 0)
        }
    }

    struct NumWound: Resolver {
        func resolve(state: GameState, ctx: PendingAction) throws -> Int {
            let maxHealth = state.player(ctx.actor).maxHealth
            let health = state.player(ctx.actor).health
            return maxHealth - health
        }
    }

    struct NumDamage: Resolver {
        func resolve(state: GameState, ctx: PendingAction) throws -> Int {
            guard case let .damage(amount, player) = ctx.event, player == ctx.actor else {
                fatalError("unexpected")
            }

            return amount
        }
    }
}

private extension Player {
    var handLimitAtEndOfTurn: Int {
        handLimit ?? health
    }
}