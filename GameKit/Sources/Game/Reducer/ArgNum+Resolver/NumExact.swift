//
//  NumExact.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

struct NumExact: ArgNumResolverProtocol {
    let number: Int

    func resolve(state: GameState, ctx: EffectContext) throws -> Int {
        number
    }
}
