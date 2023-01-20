//
//  EffectMock.swift
//  
//
//  Created by Hugues Telolahy on 18/01/2023.
//
@testable import GameRules

struct EffectMock: Effect, Equatable {
    @EquatableIgnore var playCtx: PlayContext = PlayContextImpl()
    
    func resolve(_ ctx: Game) -> Result<EventOutput, GameError> {
        .success(EventOutputImpl(state: ctx))
    }
}
