//
//  PlayerActor.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// who is playing the card
public struct PlayerActor: ArgPlayer, Equatable {

    public init() {}
    
    
    public func resolve(_ ctx: Game, playCtx: PlayContext) -> Result<ArgResolved, GameError> {
        .success(.identified([playCtx.actor]))
    }
}
