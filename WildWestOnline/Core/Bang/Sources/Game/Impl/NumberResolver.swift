//
//  NumberResolver.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 31/10/2024.
//

extension ActionSelector.Number {
    func resolve(ctx: Context, state: GameState) -> Int {
        resolver.resolve(ctx: ctx, state: state)
    }

    struct Context {
        let actor: String
    }
}

private extension ActionSelector.Number {
    protocol Resolver {
        func resolve(ctx: Context, state: GameState) -> Int
    }

    var resolver: Resolver {
        switch self {
        case .value(let rawValue): Value(rawValue: rawValue)
        case .activePlayers: ActivePlayers()
        case .excessHand: ExcessHand()
        }
    }

    struct Value: Resolver {
        let rawValue: Int

        func resolve(ctx: Context, state: GameState) -> Int {
            rawValue
        }
    }

    struct ActivePlayers: Resolver {
        func resolve(ctx: Context, state: GameState) -> Int {
            state.playOrder.count
        }
    }

    struct ExcessHand: Resolver {
        func resolve(ctx: Context, state: GameState) -> Int {
            let playerObj = state.players.get(ctx.actor)
            let handlLimit = if playerObj.handLimit > 0 {
                playerObj.handLimit
            } else {
                playerObj.health
            }

            let handCount = playerObj.hand.count
            return max(handCount - handlLimit, 0)
        }
    }
}
