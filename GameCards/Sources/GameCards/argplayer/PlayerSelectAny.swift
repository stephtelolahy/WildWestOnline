//
//  PlayerSelectAny.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
import GameRules

/// any other player
public struct PlayerSelectAny: ArgPlayer, Equatable {
    
    public init() {}
    
    public func resolve(_ ctx: Game, eventCtx: EventContext) -> Result<ArgOutput, Error> {
        let others = ctx.playOrder.filter { $0 != eventCtx.actor }
        return .success(.selectable(others.toOptions()))
    }
}
