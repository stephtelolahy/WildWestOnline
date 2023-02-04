//
//  PlayerSelectReachable.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
import GameCore

/// select any reachable player
public struct PlayerSelectReachable: ArgPlayer, Equatable {
    
    public init() {}
    
    public func resolve(_ ctx: Game, eventCtx: EventContext) -> Result<ArgOutput, Error> {
        let playerObj = ctx.player(eventCtx.actor)
        let distance = playerObj.weapon
        return PlayerSelectAt(distance).resolve(ctx, eventCtx: eventCtx)
    }
}
