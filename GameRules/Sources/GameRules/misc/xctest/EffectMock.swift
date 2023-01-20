//
//  EffectMock.swift
//  
//
//  Created by Hugues Telolahy on 18/01/2023.
//

public struct EffectMock: Effect, Equatable {
    @EquatableIgnore public var playCtx: PlayContext = PlayContextImpl()
    
    public init() {}
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, GameError> {
        .success(EventOutputImpl(state: ctx))
    }
}
