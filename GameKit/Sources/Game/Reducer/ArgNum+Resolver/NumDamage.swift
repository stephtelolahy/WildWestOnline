//
//  NumDamage.swift
//  
//
//  Created by Hugues Telolahy on 03/11/2023.
//

struct NumDamage: ArgNumResolver {
    func resolve(state: GameState, ctx: ArgNumContext) throws -> Int {
        1
    }
}
