//
//  EventReq.swift
//
//
//  Created by Hugues Telolahy on 03/06/2023.
//

/// Function defining occurred event to play a card
public enum EventReq: Codable, Equatable, Hashable {

    /// After playing an immediate effect card, then the card is discarded
    case onPlayImmediate

    /// After playing an ability
    case onPlayAbility

    /// After playing an equipment card, put in self's play
    case onPlayEquipment

    /// After playing a handicap card, put in target's play
    case onPlayHandicap

    /// After setting turn
    case onSetTurn
    
    /// After loosing last life point
    case onLooseLastHealth

    /// After being eliminated
    case onEliminated

    /// After being forced to discard hand card named X
    case onForceDiscardHandNamed(String)

    /// After inPlay card get discarded
    case onDiscardedInPlay
}
