//
//  Player.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 09/12/2022.
//

public protocol Player {
    
    /// player unique identifier
    var id: String { get }
    
    /// player name
    var name: String { get }
    
    /// max health
    var maxHealth: Int { get }
    
    /// current health
    var health: Int { get set }
    
    /// abilities
    var ability: [Card] { get }
    
    /// hand cards
    var hand: [Card] { get set }
    
    /// in play cards
    var inPlay: [Card] { get }
}
