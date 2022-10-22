//
//  IsTimesPerTurn.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//
import CardGameCore

/// The maximum times per turn this card may be played is X
public struct IsTimesPerTurn: PlayReq {
    
    let maxTimes: Int
    
    public func verify(state: State, actor: String, card: Card) -> Result<Void, Error> {
        /// No limit
        if maxTimes == 0 {
            return .success
        }
        
        let playedTimes = state.played.filter { $0 == card.name }.count
        guard playedTimes < maxTimes else {
            return .failure(ErrorIsTimesPerTurn(count: maxTimes))
        }
        
        return .success
    }
}
