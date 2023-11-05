//
//  PlayReq.swift
//  
//
//  Created by Hugues Telolahy on 15/10/2023.
//

/// Condition triggering card effect
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

    /// After being damaged
    case onDamage

    /// After loosing last life point
    case onDamageLethal

    /// After being eliminated
    case onEliminated

    /// After being targeted by a shot
    case onShot

    /// After adding or removing card inPlay
    case onUpdateInPlay

    /// After playing a weapon
    case onPlayWeapon

    /// The minimum number of active players is X
    case isPlayersAtLeast(Int)

    /// The maximum times per turn a card may be played is X
    case isCardPlayedLessThan(String, ArgNum)

    /// The current turn is actor
    case isYourTurn
}
