//
//  Inventory.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Providing cards
public protocol Inventory {
    
    func getCard(_ name: String, withId: String?) -> Card
    func getAll(_ type: CardType) -> [Card]
}
