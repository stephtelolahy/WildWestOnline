//
//  EffectMock.swift
//  
//
//  Created by Hugues Telolahy on 18/01/2023.
//
@testable import GameRules

struct EffectMock: Event, Equatable {
    @EquatableIgnore var eventCtx: EventContext = EventContextImpl()
    
    func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        .success(EventOutputImpl(state: ctx))
    }
}
