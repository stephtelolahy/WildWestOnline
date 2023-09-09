//
//  NumArg+Resolver.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

extension NumArg {
    func resolve(state: GameState, ctx: EffectContext) throws -> Int {
        try resolver().resolve(state: state, ctx: ctx)
    }
}

protocol NumArgResolverProtocol {
    func resolve(state: GameState, ctx: EffectContext) throws -> Int
}

private extension NumArg {
    func resolver() -> NumArgResolverProtocol {
        switch self {
        case .exact(let number):
            NumExact(number: number)
        case .numPlayers:
            NumPlayers()
        case .excessHand:
            NumExcessHand()
        case .playerAttr(let key):
            NumPlayerAttr(key: key)
        }
    }
}
