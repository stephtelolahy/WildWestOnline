//
//  Game.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 09/12/2022.
//

/// All game objects
public protocol Game {
    
    /// all players
    var players: [String: Player] { get }
    
    /// active players, playing order
    var playOrder: [String] { get }
    
    /// current player
    var turn: String { get }
    
    /// current phase
    var phase: Int { get }
    
    /// deck
    var deck: [Card] { get }
    
    /// discard pile
    var discard: [Card] { get }
    
    /// choosable zone
    var store: [Card] { get }
    
    /// is Game over
    var isOver: Bool { get }
    
    /// played cards during current turn
    var played: [String] { get }
    
    /// pending actions among which one must be choosen to proceed effect resolving
    var decisions: [Move] { get }
    
    /// effects queue that have to be resolved in order
    var queue: [Effect] { get }
    
    /// last occurred event
    var event: Event? { get }
}
