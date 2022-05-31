//
//  Card.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 30/05/2022.
//

/// Describing card
public struct Card {
    
    /// card unique identifier
    public var id: String = ""
    
    /// card name
    public var name: String = ""
    
    /// card value
    public var value: String = ""
    
    /// filter to select target player while playing this card
    /// for numeric value: select a player at given distance
    public var target: String?
    
    /// hand card to discard before playing this card
    public var cost: Int = 0
    
    /// when to play this card
    public var activationMode: ActivationMode = .active
    
    /// play requirements
    public var canPlay: [PlayReq] = []
    
    /// side effects on playing this card
    public var onPlay: [Effect] = []
}

public extension Card {
    
    enum ActivationMode: String {
        
        /// active during your turn
        case active
        
        /// active while your turn not prepared
        case activePrepareTurn
        
        /// active out of your turn
        case activeOutOfTurn
        
        /// automatically played responding to a specific event
        case triggered
        
        /// always on
        case passive
    }
    
    enum PlayMode {
        
        /// Discard immediately, apply some effects
        case action
        
        /// put on actor's inPlay
        case equip
        
        /// put on other playe's inPlay
        case handicap
    }
}
