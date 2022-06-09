//
//  SequenceNode.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 09/06/2022.
//

/// A Sequence is what begins when a Player Action is taken.
/// Consists of one or more Effects that are resolved in order.
public class SequenceNode {
    
    /// effect to be resolved
    let effect: Effect
    
    /// who is playing the card
    let actor: String
    
    /// selected argument during effect resolution
    var selectedArg: String?
    
    public init(effect: Effect, actor: String) {
        self.effect = effect
        self.actor = actor
    }
}
