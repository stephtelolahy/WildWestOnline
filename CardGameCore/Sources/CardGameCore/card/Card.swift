//
//  Card.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 30/05/2022.
//

/// Describing card
public struct Card: Equatable {
    
    /// card unique identifier
    public var id: String
    
    /// card name
    public let name: String
    
    /// card type
    public let type: CardType?
    
    /// prototype or parent card name
    /// this card will inherit the same `canPlay` and `onPlay attributes
    public let prototype: String?
    
    /// play requirements
    @EquatableNoop
    public var canPlay: [PlayReq]
    
    /// side effects on playing this card
    @EquatableNoop
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
    
    /// card that can be collected from deck and played manually
    case collectible
    
    /// built-in card
    /// attributed to any players
    case inner
    
    /// card that is specific to a character
    case character
}
