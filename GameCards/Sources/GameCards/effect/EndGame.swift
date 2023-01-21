//
//  EndGame.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//
import GameRules

/// Mark game over
public struct EndGame: Effect, Equatable {
    @EquatableIgnore public var playCtx: PlayContext = PlayContextImpl()
    
    public init() {}

    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        var ctx = ctx
        ctx.isOver = true
        return .success(EventOutputImpl(state: ctx))
    }
}
