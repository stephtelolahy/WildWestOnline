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
    
    /// card value
    var value: String? { get set }
    
    /// way of playing this card
    var playMode: PlayMode? { get }
    
    /// required target to play this card
    var playTarget: ArgPlayer? { get }
    
    /// requirements for playing this card
    var canPlay: [PlayReq]? { get }
    
    /// side effects on playing this card
    var onPlay: [Event]? { get }
    
    /// requirements to trigger this card
    var triggers: [PlayReq]? { get }
    
    /// triggered effects
    var onTrigger: [Event]? { get }
}