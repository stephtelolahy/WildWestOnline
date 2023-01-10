//
//  PlayReq.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 09/12/2022.
//

/// Elemenetary condition to play a card
public enum PlayReq: Codable, Equatable {
    
    /// The minimum number of alive players is X
    case isPlayersAtLeast(Int)
    
    /// The maximum times per turn this card may be played is X
    case isTimesPerTurn(Int)
}
