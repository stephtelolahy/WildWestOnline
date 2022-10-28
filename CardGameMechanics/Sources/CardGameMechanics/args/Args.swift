//
//  Args.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//
// swiftlint:disable identifier_name

/// Any card scripting argument
public enum Args {}

public extension String {
    
    // MARK: - Effect's card
    
    /// random hand card
    static let CARD_RANDOM_HAND = "CARD_RANDOM_HAND"
    
    /// all cards
    static let CARD_ALL = "CARD_ALL"
    
    /// select any card
    static let CARD_SELECT_ANY = "CARD_SELECT_ANY"
    
    /// select a hand card
    static let CARD_SELECT_HAND = "CARD_SELECT_HAND"
    
    // MARK: - Effect type
    
    /// well known shoot effect
    static let TYPE_SHOOT = "TYPE_SHOOT"
    
    // MARK: - Number
    
    /// Number of active players
    static let NUM_PLAYERS = "NUM_PLAYERS"
    
    /// Number of excess cards
    static let NUM_EXCESS_HAND = "NUM_EXCESS_HAND"
    
    // MARK: - Player
    
    /// who is playing the card
    static let PLAYER_ACTOR = "PLAYER_ACTOR"
    
    /// other players
    static let PLAYER_OTHERS = "PLAYER_OTHERS"
    
    /// all players
    static let PLAYER_ALL = "PLAYER_ALL"
    
    /// player after current turn
    static let PLAYER_NEXT = "PLAYER_NEXT"
    
    /// select any other player
    static let PLAYER_SELECT_ANY = "PLAYER_SELECT_ANY"
    
    /// select any reachable player
    static let PLAYER_SELECT_REACHABLE = "PLAYER_SELECT_REACHABLE"
    
    /// select any player at distance of 1
    static let PLAYER_SELECT_AT_1 = "PLAYER_SELECT_AT_1"
    
    /// previous effect's target
    static let PLAYER_TARGET = "PLAYER_TARGET"
    
    /// all damaged players
    static let PLAYER_DAMAGED = "PLAYER_DAMAGED"
}
