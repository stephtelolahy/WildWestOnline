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
    var isOver: Bool { get set }
    
    /// played cards during current turn
    var played: [String] { get set }
    
    /// pending actions among which one must be choosen to proceed effect resolving
    var options: [Effect] { get set }
    
    /// current actor
    var currentActor: String? { get set }
    
    /// currently played card
    var currentCard: Card? { get set }
    
    /// current player id
    var currentPlayer: String? { get set }
    
    /// last occurred event
    var event: Result<Effect, GameError>? { get set }
    
    // MARK: - Convenience
    
    /// Get player with given identifier
    func player(_ id: String) -> Player
}
