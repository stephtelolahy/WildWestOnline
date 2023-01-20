//
//  Game+Extensions.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
import GameRules

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
