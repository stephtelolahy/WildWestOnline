//
//  CancelEffect.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//
import GameRules

/// Cancel a queued event
public struct Cancel: Effect, Equatable {
    @EquatableIgnore public var playCtx: PlayContext = PlayContextImpl()
    
    public init() {}
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, GameError> {
        .success(EventOutputImpl(cancel: CancellerDefaultImpl()))
    }
}

struct CancellerDefaultImpl: Canceller {
    
    func match(_ event: Event) -> Bool {
        true
    }
}
