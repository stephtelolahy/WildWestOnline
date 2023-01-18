//
//  Player+Extensions.swift
//  
//
//  Created by Hugues Telolahy on 18/01/2023.
//

extension Player {
    func card(_ id: String) -> Card {
        if let handCard = hand.first(where: { $0.id == id }) {
            return handCard
        }
        
        if let abilityCard = abilities.first(where: { $0.id == id }) {
            return abilityCard
        }
        
        if let inPlayCard = inPlay.first(where: { $0.id == id }) {
            return inPlayCard
        }
        
        fatalError(.missingPlayerCard(id))
    }
}
