//
//  Repeat.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
import GameCore
import ExtensionsKit

/// Repeat an effect
public struct Repeat: Event, Equatable {
    @EquatableCast private var times: ArgNumber
    @EquatableCast private var effect: Event
    @EquatableIgnore public var eventCtx: EventContext = EventContextImpl()
    
    public init(times: ArgNumber, effect: Event) {
        self.times = times
        self.effect = effect
    }
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        switch times.resolve(ctx, eventCtx: eventCtx) {
        case let .failure(error):
            return .failure(error)
            
        case let .success(number):
            guard number > 0 else {
                return .success(EventOutputImpl())
            }
            
            let children: [Event] = (0..<number).map { _ in effect.withCtx(eventCtx) }
            
            return .success(EventOutputImpl(children: children))
        }
    }
}
