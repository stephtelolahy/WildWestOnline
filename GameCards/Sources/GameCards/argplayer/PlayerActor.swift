//
//  PlayerActor.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
import GameRules

/// who is playing the card
public struct PlayerActor: ArgPlayer, Equatable {

    public init() {}
    
    public func resolve(_ ctx: Game, playCtx: PlayContext) -> Result<ArgOutput, GameError> {
        .success(.identified([playCtx.actor]))
    }
}
