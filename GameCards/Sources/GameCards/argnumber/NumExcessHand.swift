//
//  NumExcessHand.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
import GameRules

/// Number of excess cards
public struct NumExcessHand: ArgNumber, Equatable {
    
    public init() {}
    
    public func resolve(_ ctx: Game, playCtx: PlayContext) -> Result<Int, Error> {
        let actorObj = ctx.player(playCtx.actor)
        let value = max(actorObj.hand.count - actorObj.handLimit, 0)
        return .success(value)
    }
}
