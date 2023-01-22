//
//  Event+PlayContext.swift
//  
//
//  Created by Hugues Telolahy on 16/01/2023.
//

public extension Event {
    
    /// Set event Context
    func withCtx(_ eventCtx: EventContext) -> Event {
        var copy = self
        copy.eventCtx = eventCtx
        return copy
    }
}

public extension Array where Element == Event {
    
    /// Set event Context
    func withCtx(_ eventCtx: EventContext) -> [Event] {
        self.map { $0.withCtx(eventCtx) }
    }
}
