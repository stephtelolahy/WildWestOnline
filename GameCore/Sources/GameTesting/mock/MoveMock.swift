//
//  MoveMock.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
import GameCore
import ExtensionsKit

public struct MoveMock: Move, Equatable {
    public let actor: String = ""
    @EquatableIgnore public var eventCtx: EventContext = EventContextImpl()

    public init() {}
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        .success(EventOutputImpl(state: ctx))
    }
}
