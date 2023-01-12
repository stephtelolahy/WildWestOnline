//
//  Card.swift
//
//
//  Created by TELOLAHY Hugues Stéphano on 09/12/2022.
//

/// Card description
public protocol Card {
    
    /// card unique identifier
    var id: String { get }
    
    /// card name
    var name: String { get }
    
    /// card value
    var value: String { get }
    
    /// card type
    var type: CardType { get }
    
    /// play requirements
    var canPlay: [PlayReq] { get }
    
    /// side effects on playing this card
    var onPlay: [Effect] { get }
}

/// Card type
public enum CardType: String {
    
    /// card that can be collected from deck and played during player's turn
    case collectible
    
    /// implements a player ability
    case ability
}
