//
//  EffectMock.swift
//  
//
//  Created by Hugues Telolahy on 18/01/2023.
//
import GameCore
import GameUtils

public struct EffectMock: Event, Equatable {
    @EquatableIgnore public var eventCtx: EventContext = EventContextImpl()

    public init() {}
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        .success(EventOutputImpl(state: ctx))
    }
}
