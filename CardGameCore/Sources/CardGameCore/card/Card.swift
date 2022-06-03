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
    public var canPlay: [PlayReq] = []
    
    /// side effects on playing this card
    public var onPlay: [Effect] = []
    
    public init(id: String = "", name: String = "") {
        self.id = id
        self.name = name
    }
}
