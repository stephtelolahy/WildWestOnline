//
//  Event.swift
//  
//
//  Created by Hugues Telolahy on 03/03/2023.
//

/// Function that causes any change in the game state
public protocol Event {
    func resolve(_ ctx: Game) -> Result<EventOutput, Error>
}

/// Resolving an event may update game or push another event
public struct EventOutput {

    /// Updated state
    public let state: Game?

    /// Children to be queued for resolving
    public let children: [Event]?

    public init(state: Game? = nil, children: [Event]? = nil) {
        self.state = state
        self.children = children
    }
}
