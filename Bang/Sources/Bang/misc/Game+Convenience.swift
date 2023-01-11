//
//  Game+Convenience.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

public extension Game {
    
    /// Get player with given identifier
    func player(_ id: String) -> Player {
        guard let playerObject = players[id] else {
            fatalError(.missingPlayer(id))
        }
        
        return playerObject
    }
}

/// Internal usage only
extension Game {
    
    /// Remove top deck card
    /// reseting deck if empty
    mutating func removeTopDeck() -> Card {
        if deck.isEmpty,
           discard.count >= 2 {
            let cards = discard
            deck.append(contentsOf: cards.dropLast().shuffled())
            discard = cards.suffix(1)
        }
        
        return deck.removeFirst()
    }
}
