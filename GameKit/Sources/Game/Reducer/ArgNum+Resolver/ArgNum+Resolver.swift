//
//  ArgNum+Resolver.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

protocol ArgNumResolver {
    func resolve(state: GameState, ctx: ArgNumContext) throws -> Int
}

struct ArgNumContext {
    let actor: String
}

extension ArgNum {
    func resolve(state: GameState, ctx: ArgNumContext) throws -> Int {
        try resolver().resolve(state: state, ctx: ctx)
    }
}

private extension ArgNum {
    func resolver() -> ArgNumResolver {
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