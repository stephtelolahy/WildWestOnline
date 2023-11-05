//
//  ArgNum+Resolver.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

protocol ArgNumResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> Int
}

extension ArgNum {
    func resolve(state: GameState, ctx: EffectContext) throws -> Int {
        try resolver().resolve(state: state, ctx: ctx)
    }
}

private extension ArgNum {
    func resolver() -> ArgNumResolver {
        switch self {
        case .exact(let number):
            NumExact(number: number)
        case .activePlayers:
            NumActivePlayers()
        case .excessHand:
            NumExcessHand()
        case .attr(let key):
            NumPlayerAttr(key: key)
        case .damage:
            NumDamage()
        }
    }
}
