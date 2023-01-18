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
        CardList.collectible
    }
    
    public func getAbilities() -> [Card] {
        CardList.abilities
    }
    
    public func getFigures() -> [Card] {
        CardList.figures
    }
    
    public func getDeck() -> [Card] {
        let cardSets = CardList.cardSets
        let uniqueCards = CardList.collectible
        var cards: [Card] = []
        for (key, values) in cardSets {
            if let card = uniqueCards.first(where: { $0.name == key }) {
                for value in values {
                    cards.append(card
                        .withValue(value)
                        .withId("\(key)-\(value)"))
                }
            }
        }
        return cards
    }
}

private extension InventoryImpl {
    
    var allCards: [CardImpl] {
        CardList.collectible + CardList.abilities
    }
}
