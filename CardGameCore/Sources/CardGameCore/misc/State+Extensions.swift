//
//  File.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 31/05/2022.
//

extension State {
    
    /// Get `non-null` `Player` with given identifier
    func player(_ id: String) -> Player {
        guard let result = players[id] else {
            fatalError(.playerNotFound(id))
        }
        return result
    }
    
    /// Get `non-null` `PlaySequence` with given card
    func sequence(_ cardRef: String) -> Sequence {
        guard let result = sequences[cardRef] else {
            fatalError(.sequenceNotFound(cardRef))
        }
        return result
    }
    
    /// Get `Decision` waiting a given action
    func decision<T: Equatable>(waiting move: T) -> Decision? {
        decisions.first { $0.value.options.contains { $0 as? T == move } }?.value
    }
    
    /// Get players within given distance
    func playersAt(_ distance: Int, actor: String) -> [String] {
        #warning("implement distance rules")
        return playOrder.filter { $0 != actor }
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
