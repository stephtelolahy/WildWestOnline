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
    var playOrder: [String] { get set }
    
    /// current player
    var turn: String? { get set }
    
    /// deck
    var deck: [Card] { get set }
    
    /// discard pile
    var discard: [Card] { get set }
    
    /// choosable zone
    var store: [Card] { get set }
    
    /// is Game over
    var isOver: Bool { get }
    
    /// played cards during current turn
    var played: [String] { get set }
    
    /// pending actions among which one must be choosen to proceed effect resolving
    var options: [Effect] { get set }
    
    /// effects queue that have to be resolved in order
    var queue: [Effect] { get set }
    
    /// queue's actor
    var queueActor: String? { get set }
    
    /// queue's card
    var queueCard: Card? { get set }
    
    /// queue's current player id
    var queuePlayer: String? { get set }
    
    /// last occurred event
    var event: Result<Effect, GameError>? { get set }
    
    // MARK: - Convenience
    
    /// Get player with given identifier
    func player(_ id: String) -> Player
}
