//
//  Event.swift
//  
//
//  Created by Hugues Telolahy on 18/01/2023.
//

/// Engine queue's event
public protocol Event {
    func resolve(_ ctx: Game) -> Result<EventOutput, GameError>
}

/// Resolving an event may update game or push another event
public protocol EventOutput {
    
    /// Updated `State`
    var state: Game? { get }
    
    /// Children on resolving
    var children: [Event]? { get }
}
