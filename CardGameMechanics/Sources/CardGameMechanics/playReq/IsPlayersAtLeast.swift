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
    
    func verify(state: State, actor: String, card: Card) -> Result<Void, Error> {
        guard state.playOrder.count >= count else {
            return .failure(ErrorIsPlayersAtLeast(count: count))
        }
        
        return .success
    }
}
