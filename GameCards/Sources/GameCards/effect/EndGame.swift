//
//  EndGame.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//
import GameCore
import ExtensionsKit

/// Mark game over
public struct EndGame: Event, Equatable {
    @EquatableIgnore public var eventCtx: EventContext = EventContextImpl()
    
    public init() {}

    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        var ctx = ctx
        ctx.isOver = true
        return .success(EventOutputImpl(state: ctx))
    }
}
