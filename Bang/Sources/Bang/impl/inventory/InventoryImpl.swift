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
    
    public func getDeck() -> [Card] {
        let cardSets = Bang.cardSets
        let uniqueCards = Bang.collectibleCards
        var cards: [Card] = []
        for (key, values) in cardSets {
            if let card = uniqueCards.first(where: { $0.name == key }) {
                for value in values {
                    var copy = card
                    copy.value = value
                    copy.id = "\(key)-\(value)"
                    cards.append(copy)
                }
            }
        }
        return cards
    }
}

private extension InventoryImpl {
    
    var allCards: [CardImpl] {
        Bang.collectibleCards + Bang.abilities
    }
}
