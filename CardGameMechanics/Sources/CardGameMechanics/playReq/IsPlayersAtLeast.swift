//
//  IsPlayersAtLeast.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//
import CardGameCore

/// The minimum number of alive players is X
struct IsPlayersAtLeast: PlayReq {
    
    let count: Int
    
    func verify(ctx: State, actor: String, card: Card) -> Result<Void, Error> {
        guard ctx.playOrder.count >= count else {
            return .failure(ErrorPlayersMustBeAtLeast(count: count))
        }
        
        return .success
    }
}
