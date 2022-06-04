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
    
    public let prototype: String?
    
    /// play requirements
    public var canPlay: [PlayReq]
    
    /// side effects on playing this card
    public var onPlay: [Effect]
    
    /// card value
    public var value: String = ""
    
    public init(id: String = "", name: String = "", prototype: String? = nil, canPlay: [PlayReq] = [], onPlay: [Effect] = []) {
        self.id = id
        self.name = name
        self.prototype = prototype
        self.canPlay = canPlay
        self.onPlay = onPlay
    }
}
