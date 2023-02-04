//
//  Cancel.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//
import ExtensionsKit

/// Cancel some queued events
public struct Cancel: Event, Equatable {
    @EquatableIgnore public var eventCtx: EventContext = EventContextImpl()
    
    public init() {}
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        fatalError(InternalError.unexpected)
    }
}
