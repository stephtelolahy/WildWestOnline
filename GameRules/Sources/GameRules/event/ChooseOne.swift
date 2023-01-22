//
//  ChooseOne.swift
//  
//
//  Created by Hugues Telolahy on 17/01/2023.
//

/// Choose one of pending actions to proceed effect resolving
public struct ChooseOne: Event, Equatable {
    @EquatableIgnore public var options: [Move]
    @EquatableIgnore public var eventCtx: EventContext = EventContextImpl()
    
    public init(_ options: [Move]) {
        assert(!options.isEmpty)
        
        self.options = options
    }
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        fatalError(InternalError.unexpected)
    }
}
