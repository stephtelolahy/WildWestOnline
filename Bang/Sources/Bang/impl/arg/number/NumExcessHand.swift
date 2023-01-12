//
//  NumExcessHand.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// Number of excess cards
public struct NumExcessHand: ArgNumber, Equatable {
    
    public init() {}
    
    public func resolve(_ ctx: Game) -> Result<Int, GameError> {
        let actorObj = ctx.player(ctx.actor)
        let value = max(actorObj.hand.count - actorObj.handLimit, 0)
        return .success(value)
    }
}
