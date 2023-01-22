//
//  Event.swift
//  
//
//  Created by Hugues Telolahy on 18/01/2023.
//

/// Engine queue's event
public protocol Event {
    func resolve(_ ctx: Game) -> Result<EventOutput, Error>
}

/// Resolving an event may update game or push another event
public protocol EventOutput {
    
    /// Updated `State`
    var state: Game? { get }
    
    /// Children to be queued for resolving
    var children: [Event]? { get }
    
    /// Function to cancel some queued event
    var cancel: Canceller? { get }
}

/// Function used to cancel event
public protocol Canceller {
    
    func match(_ event: Event) -> Bool
}
