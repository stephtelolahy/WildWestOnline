//
//  Inventory.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Providing cards
public protocol Inventory {
    
    /// get card with given name
    func getCard(_ name: String, withId: String) -> Card
    
    /// get all playable cards
    func getCollectibleCards() -> [Card]
    
    /// get all default player abilities
    func getAbilities() -> [Card]
    
    /// build  deck
    func getDeck() -> [Card]
}