//
//  State+Extensions.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 09/06/2022.
//
import CardGameCore

extension State {
    
    /// Get players within given distance
    func playersAt(_ distance: Int, actor: String) -> [String] {
        playOrder.filter { $0 != actor }
    }
    
    /// Remove top deck card
    mutating func removeTopDeck() -> Card {
        // reseting deck if empty
        if deck.isEmpty,
           discard.count >= 2 {
            let cards = discard
            deck.append(contentsOf: cards.dropLast().shuffled())
            discard = cards.suffix(1)
        }
        
        return deck.removeFirst()
    }
}
