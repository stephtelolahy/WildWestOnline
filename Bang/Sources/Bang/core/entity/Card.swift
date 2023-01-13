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
    
    /// play requirements
    var canPlay: [PlayReq] { get }
    
    /// side effects on playing this card
    var onPlay: [Effect] { get }
}
