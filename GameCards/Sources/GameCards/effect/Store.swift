//
//  Store.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//
import GameRules

/// Draw card from deck to store zone
public struct Store: Effect, Equatable {
    @EquatableIgnore public var playCtx: PlayContext = PlayContextImpl()
    
    public init() {}
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        var ctx = ctx
        let card = ctx.removeTopDeck()
        ctx.store.append(card)
        
        return .success(EventOutputImpl(state: ctx))
    }
}
