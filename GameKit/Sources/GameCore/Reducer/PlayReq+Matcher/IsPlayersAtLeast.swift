//
//  IsPlayersAtLeast.swift
//  
//
//  Created by Hugues Telolahy on 09/04/2023.
//

struct IsPlayersAtLeast: PlayReqMatcher {
    let minCount: Int

    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        state.playOrder.count >= minCount
    }
}
