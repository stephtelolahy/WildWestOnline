//
//  PlayReq.swift
//
//
//  Created by Hugues Telolahy on 15/10/2023.
//

/// Condition triggering card effect
public indirect enum PlayReq: Codable, Equatable {
    /// playing a card
    case play

    /// setting turn
    case setTurn

    /// being damaged
    case damage

    /// loosing last life point
    case damageLethal

    /// being eliminated
    case eliminated

    /// another player eliminated
    case anotherEliminated

    /// being targeted by a shot
    case shot

    /// adding or removing card inPlay
    case changeInPlay

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

    /// Not playReq
    case isNot(Self)
}
