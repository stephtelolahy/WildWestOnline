//
//  PlayerArg.swift
//  
//
//  Created by Hugues Telolahy on 03/04/2023.
//

/// Player argument
public enum PlayerArg: Codable, Equatable {

    /// The player identified by
    case id(String)

    /// Who is playing the card
    case actor

    /// Target player that was previously selected
    case target

    /// The next player's turn, in clockwise order.
    case next

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
}
