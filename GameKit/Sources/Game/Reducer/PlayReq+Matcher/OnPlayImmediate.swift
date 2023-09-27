//
//  OnPlayImmediate.swift
//  
//
//  Created by Hugues Telolahy on 05/09/2023.
//

struct OnPlayImmediate: PlayReqMatcherProtocol {
    func match(state: GameState, ctx: EffectContext) -> Bool {
        false
    }
}
