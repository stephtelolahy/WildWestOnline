//
//  Card.swift
//
//
//  Created by TELOLAHY Hugues Stéphano on 09/12/2022.
//

/// Card description
public protocol Card {
    
    /// card unique identifier
    var id: String { get set }
    
    /// card name
    var name: String { get }
    
    /// card value
    var value: String { get }
    
    /// requirements for playing this card
    var canPlay: [PlayReq] { get }
    
    /// side effects on playing this card
    var onPlay: [Effect] { get }
    
    /// requirements to trigger this card
    var triggers: [PlayReq] { get }
    
    /// triggered effects
    var onTrigger: [Effect] { get }
}
