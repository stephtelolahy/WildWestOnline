//
//  PlayReq.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 09/12/2022.
//

/// Elemenetary condition to play a card
public enum PlayReq: Codable, Equatable {
    
    /// Must be on phase X and no playing hit
    case isPhase(Int)
    
    /// The minimum number of alive players is X
    case isPlayersAtLeast(Int)
    
    /// The maximum times per turn this card may be played is X
    case isTimesPerTurn(Int)
}
