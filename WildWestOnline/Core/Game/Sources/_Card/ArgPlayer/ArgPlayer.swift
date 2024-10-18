//
//  ArgPlayer.swift
//  
//
//  Created by Hugues Telolahy on 03/04/2023.
//

/// Player argument
public indirect enum ArgPlayer: Codable, Equatable {
    /// The player identified by
    case id(String)

    /// Who is playing the card
    case actor

    /// The next player, in clockwise order.
    case next(Self)

    /// Select any other player
    case selectAny

    /// Select any reachable at range
    case selectAt(Int)

    /// Select any reachable player
    case selectReachable

    /// All players
    case all

    /// Other players
    case others

    /// All damaged players
    case damaged

    /// The player that deals damage to actor
    /// While actor is not playing, this should be the current turn's player 
    case offender

    /// Just eliminated player, different from `actor`
    case eliminated
}
