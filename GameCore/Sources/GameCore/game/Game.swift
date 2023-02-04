//
//  Game.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 09/12/2022.
//

/// All aspects of game state
/// These state objects are passed around everywhere and maintained on both client and server seamlessly
public protocol Game {
    
    /// all players
    var players: [String: Player] { get set }
    
    /// active players, playing order
    var playOrder: [String] { get set }
    
    /// current player
    /// A turn is a period of the game that is associated with an individual player
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
    
    /// last occurred event
    var event: Result<Event, Error>? { get set }
    
    // MARK: - Convenience
    
    /// Get player with given identifier
    func player(_ id: String) -> Player
}
