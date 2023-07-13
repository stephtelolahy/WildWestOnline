//
//  IsPlayersAtLeast.swift
//  
//
//  Created by Hugues Telolahy on 09/04/2023.
//

struct IsPlayersAtLeast: PlayReqMatcherProtocol {
    let minCount: Int

    func match(state: GameState, ctx: EffectContext) -> Bool {
        state.playOrder.count >= minCount
    }
}
