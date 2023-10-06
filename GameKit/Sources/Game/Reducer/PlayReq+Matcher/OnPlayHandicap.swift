//
//  OnPlayHandicap.swift
//  
//
//  Created by Hugues Telolahy on 05/09/2023.
//

struct OnPlayHandicap: PlayReqMatcher {
    func match(state: GameState, ctx: PlayReqContext) -> Bool {
        false
    }
}
