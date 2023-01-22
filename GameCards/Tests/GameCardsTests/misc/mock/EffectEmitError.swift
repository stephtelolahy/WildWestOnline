//
//  EffectEmitError.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
import GameRules

struct EffectEmitError: Event, Equatable {
    @EquatableCast var error: Error
    @EquatableIgnore var eventCtx: EventContext = EventContextImpl()
    
    func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        .failure(error)
    }
}
