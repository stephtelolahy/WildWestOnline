//
//  Effect+PlayContext.swift
//  
//
//  Created by Hugues Telolahy on 16/01/2023.
//

public extension Effect {
    
    /// Set playContext
    func withCtx(_ playCtx: PlayContext) -> Self {
        var copy = self
        copy.playCtx = playCtx
        return copy
    }
}

// TODO: constraints array of Effect
extension Array {
    
    /// Set playContext
    func withCtx(_ playCtx: PlayContext) -> [Effect] {
        self.map { ($0 as! Effect).withCtx(playCtx) }
    }
}
