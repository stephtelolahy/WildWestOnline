//
//  EventOutputImpl.swift
//  
//
//  Created by Hugues Telolahy on 09/01/2023.
//

public struct EventOutputImpl: EventOutput {
    public var state: Game?
    public var children: [Event]?
    
    public init(state: Game? = nil, children: [Event]? = nil) {
        assert(children == nil || children?.isEmpty == false, " children should not be empty")
        
        self.state = state
        self.children = children
    }
}
