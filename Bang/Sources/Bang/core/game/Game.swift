//
//  Game.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 09/12/2022.
//

/// All aspects of game state
public protocol Game {
    
    /// all players
    var players: [String: Player] { get set }
    
    /// active players, playing order
    var playOrder: [String] { get }
    
    /// current player
    var turn: String { get }
    
    /// deck
    var deck: [Card] { get }
    
    /// discard pile
    var discard: [Card] { get set }
    
    /// choosable zone
    var store: [Card] { get }
    
    /// is Game over
    var isOver: Bool { get }
    
    /// played cards during current turn
    var played: [String] { get set }
    
    /// pending actions among which one must be choosen to proceed effect resolving
    var decisions: [Effect] { get set }
    
    /// effects queue that have to be resolved in order
    var queue: [Effect] { get set }
    
    /// last occurred event
    /// that updated the game state
    var event: Result<Effect, GameError>? { get set }
    
    /// play context data
    var data: [ContextKey: Any] { get set }
}

public enum ContextKey: String {
    case actor
}
