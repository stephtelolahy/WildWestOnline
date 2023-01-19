//
//  PlayerImpl+Modifiers.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//

import Bang

extension PlayerImpl {
    
    /// add hand card
    func hand(_ card: Card) -> Self {
        var copy = self
        copy.hand.append(card)
        return copy
    }
    
    /// add inPlay card
    func inPlay(_ card: Card) -> Self {
        var copy = self
        copy.inPlay.append(card)
        return copy
    }
    
    /// add an ability
    func ability(_ card: Card) -> Self {
        var copy = self
        copy.abilities.append(card)
        return copy
    }
    
    func health(_ value: Int) -> Self {
        var copy = self
        copy.health = value
        return copy
    }
    
    func maxHealth(_ value: Int) -> Self {
        var copy = self
        copy.maxHealth = value
        return copy
    }
}
