//
//  SequenceNode.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 09/06/2022.
//

/// All data about resolving an effect
public class SequenceNode {
    
    /// effect to be resolved
    let effect: Effect
    
    /// the player that played the card the effects belong to
    let actor: String
    
    /// selected argument during effect resolution
    var selectedArg: String?
    
    /// target player from previous effect
    var target: String?
    
    public init(effect: Effect, actor: String) {
        self.effect = effect
        self.actor = actor
    }
}
