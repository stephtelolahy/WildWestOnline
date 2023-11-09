//
//  PlayReq.swift
//
//
//  Created by Hugues Telolahy on 15/10/2023.
//

/// Condition triggering card effect
public enum PlayReq: Codable, Equatable {

    /// playing an immediate effect card, then the card is discarded
    case playImmediate

    /// playing an ability
    case playAbility

    /// playing an equipment card, put in self's play
    case playEquipment

    /// playing a handicap card, put in target's play
    case playHandicap

    /// setting turn
    case setTurn

    /// being damaged
    case damage

    /// loosing last life point
    case damageLethal

    /// being eliminated
    case eliminated

    /// being targeted by a shot
    case shot

    /// adding or removing card inPlay
    case updateInPlay

    /// playing a weapon
    case playWeapon

    /// having no cards in hand
    case handEmpty

    /// The minimum number of active players is X
    case isPlayersAtLeast(Int)

    /// The maximum times per turn a card may be played is X
    case isCardPlayedLessThan(String, ArgNum)

    /// The current turn is actor
    case isYourTurn
}
