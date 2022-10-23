//
//  Card.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 30/05/2022.
//

/// Describing card
public struct Card {
    
    /// card unique identifier
    public var id: String
    
    /// card name
    public let name: String
    
    /// card type
    public let type: CardType?
    
    /// prototype card
    public let prototype: String?
    
    /// play requirements
    public var canPlay: [PlayReq]
    
    /// side effects on playing this card
    public var onPlay: [Effect]
    
    /// card value
    public var value: String = ""
    
    public init(
        id: String = "",
        name: String = "",
        type: CardType? = nil,
        prototype: String? = nil,
        canPlay: [PlayReq] = [],
        onPlay: [Effect] = []
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.prototype = prototype
        self.canPlay = canPlay
        self.onPlay = onPlay
    }
}

public enum CardType: String {
    
    /// playable card
    case collectible
    
    /// built-in card attributed to any players
    case inner
    
    /// specific character card
    case character
}
