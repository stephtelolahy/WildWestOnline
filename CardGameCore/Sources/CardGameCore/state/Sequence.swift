//
//  Sequence.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 31/05/2022.
//

/// A Sequence is what begins when a Player Action is taken.
/// Consists of one or more Effects that are resolved in order.
public struct Sequence {
    
    /// who is playing the card
    public let actor: String
    
    /// pending events
    public var queue: [Effect] = []
    
    public init(actor: String, queue: [Effect] = []) {
        self.actor = actor
        self.queue = queue
    }
}
