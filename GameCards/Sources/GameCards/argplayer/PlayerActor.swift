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
    
    public func resolve(_ ctx: Game, eventCtx: EventContext) -> Result<ArgOutput, Error> {
        .success(.identified([eventCtx.actor]))
    }
}
