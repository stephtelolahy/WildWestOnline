//
//  ArgResolverNumber.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//

enum ArgResolverNumber {
    
    static func resolve(_ number: ArgNumber, ctx: Game) -> Int {
        switch number {
        case .numPlayers:
            return resolveNumPlayers(ctx: ctx)
            
        case .numExcessHand:
            return resolveExcessHand(ctx: ctx)
            
        default:
            fatalError("unimplemented resolver for number \(number)")
        }
    }
}

private extension ArgResolverNumber {
    
    static func resolveNumPlayers(ctx: Game) -> Int {
        ctx.playOrder.count
    }
    
    static func resolveExcessHand(ctx: Game) -> Int {
        let actorObj = ctx.player(ctx.actor)
        return max(actorObj.hand.count - actorObj.handLimit, 0)
    }
}
