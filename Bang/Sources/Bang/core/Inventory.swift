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
    
    /// all cards of given type
    func getAll(_ type: CardType) -> [Card]
}
