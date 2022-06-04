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
    
    /// card value
    public var value: String = ""
    
    /// play requirements
    public let canPlay: [PlayReq]
    
    /// side effects on playing this card
    public let onPlay: [Effect]
    
    public init(id: String = "", name: String = "", canPlay: [PlayReq] = [], onPlay: [Effect] = []) {
        self.id = id
        self.name = name
        self.canPlay = canPlay
        self.onPlay = onPlay
    }
}
