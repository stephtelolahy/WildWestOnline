//
//  NumPlayers.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

struct NumPlayers: ArgNumResolver {
    func resolve(state: GameState, ctx: ArgNumContext) throws -> Int {
        state.playOrder.count
    }
}