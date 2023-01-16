//
//  NumExcessHand.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// Number of excess cards
public struct NumExcessHand: ArgNumber, Equatable {
    
    public init() {}
    
    public func resolve(_ ctx: Game, playCtx: PlayContext) -> Result<Int, GameError> {
        let actorObj = ctx.player(playCtx.actor)
        let value = max(actorObj.hand.count - actorObj.handLimit, 0)
        return .success(value)
    }
}
