//
//  Effect+PlayContext.swift
//  
//
//  Created by Hugues Telolahy on 16/01/2023.
//

public extension Effect {
    
    /// Set playContext
    func withCtx(_ playCtx: PlayContext) -> EffectNode {
        EffectNode(effect: self, playCtx: playCtx)
    }
    
    func asNode() -> EffectNode {
        withCtx(PlayContextImpl())
    }
}

extension Array where Element == Effect {
    
    /// Set playContext
    func withCtx(_ playCtx: PlayContext) -> [EffectNode] {
        self.map { $0.withCtx(playCtx) }
    }
}
