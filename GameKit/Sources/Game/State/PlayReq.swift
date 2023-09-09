//
//  PlayReq.swift
//  
//
//  Created by Hugues Telolahy on 03/04/2023.
//

/// Function defining state constraints to play a card
public enum PlayReq: Codable, Equatable {

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
    case onDiscardedFromPlay

    /// After playing an equipement with given attribute
    case onPlayEquipmentWithAttribute(AttributeKey)

    /// The minimum number of active players is X
    case isPlayersAtLeast(Int)

    /// The maximum times per turn a card may be played is X
    case isTimesPerTurn(NumArg)

    /// Is actor the current turn
    case isYourTurn
}
