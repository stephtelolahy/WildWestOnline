//
//  File.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 31/05/2022.
//

/// A Sequence is what begins when a Player Action is taken.
/// Consists of one or more Effects that are resolved in order.
/// It holds player choices during effect resolution
public struct Sequence {
    
    /// who is playing the card
    public let actor: String
    
    /// played card
    public let card: Card
    
    /// parent card triggering this sequence
    public var parentRef: String?
    
    /// targeted player
    public var selectedTarget: String?
    
    /// selected card by player
    public var selectedCard: [String: String] = [:]
    
    /// players that won't react to card's effects
    public var selectedPass: [String: Bool] = [:]
    
    /// pending events
    public var queue: [Effect] = []
}

extension Args {
    
    static let cardRandomHand = "CARD_RANDOM_HAND"
}
