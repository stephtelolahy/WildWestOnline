//
//  SateCondition.swift
//  
//
//  Created by Hugues Telolahy on 03/04/2023.
//

/// Function defining state constraints to play a card
public enum SateCondition: Codable, Equatable {

    /// The minimum number of active players is X
    case isPlayersAtLeast(Int)

    /// The maximum times per turn a card may be played is X
    case isCardPlayedLessThan(String, ArgNum)

    /// Is actor the current turn
    case isYourTurn

    /// Is not the current actor's turn
    case isOutOfTurn
}
