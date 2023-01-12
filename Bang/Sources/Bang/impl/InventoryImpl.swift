//
//  InventoryImpl.swift
//
//
//  Created by Hugues Telolahy on 09/01/2023.
//

public struct InventoryImpl: Inventory {
    
    public init() {}
    
    public func getCard(_ name: String, withId id: String) -> Card {
        guard var card = Bang.uniqueCards.first(where: { $0.name == name }) else {
            fatalError(.missingCardScript(name))
        }
        
        card.id = id
        return card
    }
    
    public func getAll(_ type: CardType) -> [Card] {
        Bang.uniqueCards.filter { $0.type == type }
    }
}
