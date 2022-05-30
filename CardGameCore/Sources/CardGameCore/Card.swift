//
//  Card.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 30/05/2022.
//

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
    
    /// play requirements
    var canPlay: [PlayReq] = []
    
    /// side effects on playing this card
    var onPlay: [Effect] = []
    
    public init() {}
}
