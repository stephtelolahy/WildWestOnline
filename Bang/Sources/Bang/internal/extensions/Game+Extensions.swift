//
//  Game+Extensions.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Internal usage only
extension Game {
    
    /// current actor
    var actor: String {
        guard let actorId = data[.actor] as? String else {
            fatalError(.missingActor)
        }
        
        return actorId
    }
    
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
    
    /// Get players within given distance
    func playersAtRange(_ range: Int, from player: String) -> [String] {
        // TODO: implement distance rules
        playOrder.filter { $0 != player }
    }
}
