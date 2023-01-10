//
//  PlayReq.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 09/12/2022.
//

/// Elemenetary condition to play a card
public protocol PlayReq {
    
    func verify(_ ctx: Game) -> Result<Void, GameError>
}

/*
public enum PlayReq: Codable, Equatable {
    
    /// The maximum times per turn this card may be played is X
    case isTimesPerTurn(Int)
}
*/
