//
//  OnPlayHandicap.swift
//  
//
//  Created by Hugues Telolahy on 05/09/2023.
//

struct OnPlayHandicap: PlayReqMatcherProtocol {
    func match(state: GameState, ctx: EffectContext) -> Bool {
        false
    }
}
