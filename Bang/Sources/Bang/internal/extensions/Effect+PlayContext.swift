//
//  Effect+PlayContext.swift
//  
//
//  Created by Hugues Telolahy on 16/01/2023.
//

public extension Effect {
    
    /// Set playContext
    func withCtx(_ playCtx: PlayContext) -> Effect {
        var copy = self
        copy.playCtx = playCtx
        return copy
    }
}

extension Array where Element == Effect {
    
    /// Set playContext
    func withCtx(_ playCtx: PlayContext) -> [Effect] {
        self.map { $0.withCtx(playCtx) }
    }
}
