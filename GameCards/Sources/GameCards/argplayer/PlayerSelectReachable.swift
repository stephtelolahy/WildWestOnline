//
//  PlayerSelectReachable.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
import GameRules

/// select any reachable player
public struct PlayerSelectReachable: ArgPlayer, Equatable {
    
    public init() {}
    
    public func resolve(_ ctx: Game, playCtx: PlayContext) -> Result<ArgOutput, GameError> {
        let playerObj = ctx.player(playCtx.actor)
        let distance = playerObj.weapon
        return PlayerSelectAt(distance).resolve(ctx, playCtx: playCtx)
    }
}
