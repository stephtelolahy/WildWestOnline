//
//  InventoryImpl.swift
//
//
//  Created by Hugues Telolahy on 09/01/2023.
//

public struct InventoryImpl: Inventory {
    
    public init() {}
    
    public func getCard(_ name: String, withId id: String) -> Card {
        guard var card = allCards.first(where: { $0.name == name }) else {
            fatalError(.missingCardScript(name))
        }
        
        card.id = id
        return card
    }
    
    public func getCollectibleCards() -> [Card] {
        Bang.collectibleCards
    }
    
    public func getAbilities() -> [Card] {
        Bang.abilities
    }
}

private extension InventoryImpl {
    
    var allCards: [CardImpl] {
        Bang.collectibleCards + Bang.abilities
    }
}
