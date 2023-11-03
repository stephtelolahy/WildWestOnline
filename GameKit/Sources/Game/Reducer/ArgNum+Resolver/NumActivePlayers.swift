//
//  NumActivePlayers.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

struct NumActivePlayers: ArgNumResolver {
    func resolve(state: GameState, ctx: EffectContext) throws -> Int {
        state.playOrder.count
    }
}
