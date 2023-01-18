//
//  Card.swift
//
//
//  Created by TELOLAHY Hugues Stéphano on 09/12/2022.
//

/// Card data
public protocol Card {
    
    /// card unique identifier
    var id: String { get set }
    
    /// card name
    var name: String { get }
    
    /// card description
    var desc: String { get }
    
    /// card type
    var type: CardType { get }
    
    /// card value
    var value: String { get set }
    
    /// required target to play this card
    var playTarget: ArgPlayer? { get }
    
    /// requirements for playing this card
    var canPlay: [PlayReq] { get }
    
    /// side effects on playing this card
    var onPlay: [Effect] { get }
    
    /// requirements to trigger this card
    var triggers: [PlayReq] { get }
    
    /// triggered effects
    var onTrigger: [Effect] { get }
}

/// Card playing type
public enum CardType {
    
    /// Brown card
    case action
    
    /// Blue card as equipement
    case equipment
    
    /// Blue card as handicap
    case handicap
    
    /// Inner ability
    case ability
}
