//
//  OnPlay.swift
//  
//
//  Created by Hugues Telolahy on 24/11/2023.
//

struct OnPlay: PlayReqMatcher {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        if case .play = ctx.event {
            return true
        } else {
            return false
        }
    }
}
