//
//  IsNot.swift
//  
//
//  Created by Hugues Telolahy on 21/01/2024.
//

struct IsNot: PlayReqMatcher {
    let playReq: PlayReq
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        !playReq.match(state: state, ctx: ctx)
    }
}
