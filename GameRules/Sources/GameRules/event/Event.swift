//
//  Event.swift
//  
//
//  Created by Hugues Telolahy on 18/01/2023.
//

/// Engine queue's event
/// Function that causes any change in the game state
/// May be a card effect, a move
public protocol Event {
    
    /// Resolve event
    func resolve(_ ctx: Game) -> Result<EventOutput, Error>
    
    /// Context data for resolving
    var eventCtx: EventContext { get set }
}

/// Resolving an event may update game or push another event
public protocol EventOutput {
    
    /// Updated `State`
    var state: Game? { get }
    
    /// Children to be queued for resolving
    var children: [Event]? { get }
}

/// Context data associated to an event
public protocol EventContext {
    
    /// current actor
    var actor: String { get }
    
    /// played card
    var card: Card { get }
    
    /// current target
    var target: String? { get set }
}
