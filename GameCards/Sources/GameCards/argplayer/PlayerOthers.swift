//
//  PlayerOthers.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
import GameCore

/// other players
public struct PlayerOthers: ArgPlayer, Equatable {

    public init() {}
    
    public func resolve(_ ctx: Game, eventCtx: EventContext) -> Result<ArgOutput, Error> {
        let others = Array(ctx.playOrder.starting(with: eventCtx.actor).dropFirst())
        return .success(.identified(others))
    }
}
