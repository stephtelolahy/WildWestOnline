//
//  Store.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//
import GameCore
import ExtensionsKit

/// Draw card from deck to store zone
public struct Store: Event, Equatable {
    @EquatableIgnore public var eventCtx: EventContext = EventContextImpl()
    
    public init() {}
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        var ctx = ctx
        let card = ctx.removeTopDeck()
        ctx.store.append(card)
        
        return .success(EventOutputImpl(state: ctx))
    }
}
