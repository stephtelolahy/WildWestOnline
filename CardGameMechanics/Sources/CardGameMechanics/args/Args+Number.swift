//
//  Args+Number.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 05/06/2022.
//
import CardGameCore

public extension Args {
    
    /// Number of active players
    static let numPlayers = "NUM_PLAYERS"
    
    /// Number of excess cards
    static let numExcessHand = "NUM_EXCESS_HAND"
}

extension Args {
    
    static func resolveNumber(_ number: String, actor: String, ctx: State) -> Int {
        switch number {
        case numPlayers:
            return ctx.playOrder.count
            
        case numExcessHand:
            let actorObj = ctx.player(actor)
            return max(actorObj.hand.count - actorObj.handLimit, 0)
            
        default:
            guard let value = Int(number) else {
                fatalError(.numberValueInvalid(number))
            }
            
            return value
        }
    }
}
