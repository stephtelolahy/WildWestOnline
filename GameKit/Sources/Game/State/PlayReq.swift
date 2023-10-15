//
//  PlayReq.swift
//  
//
//  Created by Hugues Telolahy on 15/10/2023.
//

/// Occurred event  triggering card effect
public enum PlayReq: String, CodingKeyRepresentable, Codable, Equatable {

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
    case onDamageLethal

    /// After being eliminated
    case onEliminated

    /// After being eliminated and current turn
    case onEliminatedYourTurn

    /// After being targeted by a shot
    case onShot

    /// After adding or removing card inPlay
    case onUpdateInPlay

    /// After playing a weapon
    case onPlayWeapon
}
