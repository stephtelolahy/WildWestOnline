//
//  EffectMock.swift
//  
//
//  Created by Hugues Telolahy on 21/01/2023.
//

import GameRules

struct EffectMock: Event, Equatable {
    @EquatableIgnore var eventCtx: EventContext = EventContextImpl()
    
    func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        .success(EventOutputImpl(state: ctx))
    }
}
