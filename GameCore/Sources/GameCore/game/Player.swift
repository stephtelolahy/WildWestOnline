//
//  Player.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 09/12/2022.
//

/// Player data
public protocol Player {
    
    /// player unique identifier
    var id: String { get }
    
    /// player name
    var name: String { get }
    
    /// max health
    var maxHealth: Int { get }
    
    /// current health
    var health: Int { get set }
    
    /// Maximum allowed hand cards at the end of his turn
    var handLimit: Int { get }
    
    /// Weapon range
    var weapon: Int { get }
    
    /// Increment distance from others
    var mustang: Int { get }
    
    /// Decrement distance to others
    var scope: Int { get }
    
    /// abilities
    var abilities: [Card] { get }
    
    /// hand cards
    var hand: [Card] { get set }
    
    /// in play cards
    var inPlay: [Card] { get set }
    
    // MARK: - Convenience
    
    /// Get card with given identifier
    func card(_ id: String) -> Card
}