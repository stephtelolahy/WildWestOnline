//
//  File.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 31/05/2022.
//

/// Stores the information of the game state of all players.
public struct State {
    
    /// all players by player identifier
    public var players: [String: Player] = [:]
    
    /// active players, playing order
    public var playOrder: [String] = []
    
    /// current player
    public var turn: String?
    
    /// ask player to draw 2 cards before starting his turn
    public var turnNotStarted = false
    
    /// played cards during current turn
    public var turnPlayed: [String] = []
    
    /// deck
    public var deck: [Card] = []
    
    /// discard pile
    public var discard: [Card] = []
    
    /// choosable zone
    public var store: [Card] = []
    
    /// played cards sequence
    var sequences: [String: Sequence] = [:]
    
    /// pending action by player
    public var decisions: [String: Decision] = [:]
    
    /// is Game over
    public var isGameOver = false
}
