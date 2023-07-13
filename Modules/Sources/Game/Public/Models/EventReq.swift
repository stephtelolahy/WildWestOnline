//
//  EventReq.swift
//  
//
//  Created by Hugues Telolahy on 03/06/2023.
//

/// Function defining occurred event to play a card
public enum EventReq: Codable, Equatable {

    /// After playing a card
    case onPlay

    /// After setting turn
    case onSetTurn

    /// After loosing last life point
    case onLooseLastHealth

    /// After being eliminated
    case onEliminated
    
    /// After being forced to discard hand card named X
    case onForceDiscardHandNamed(String)
}
