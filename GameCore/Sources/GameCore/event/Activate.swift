//
//  Activate.swift
//  
//
//  Created by Hugues Telolahy on 17/01/2023.
//
import ExtensionsKit

/// Emit active moves
public struct Activate: Event, Equatable {
    @EquatableCast public var moves: [Move]
    @EquatableIgnore public var eventCtx: EventContext = EventContextImpl()
    
    public init(_ moves: [Move]) {
        self.moves = moves
    }
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        fatalError(InternalError.unexpected)
    }
}
