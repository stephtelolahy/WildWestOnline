//
//  Effect.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 30/05/2022.
//

/// Effects are card abilities that update the game state
/// The process of resolving an efect is similar to a depth-first search
public protocol Effect: Event {
    func resolve(ctx: State, actor: String) -> EffectResult
}

public enum EffectResult {
    
    /// Resolved with an outcome `State`, remove it from queue
    case success(State)
    
    /// Failed with an `Error`, remove it from queue
    case failed(Event)
    
    /// Suspended waiting user decision among an array of `Move`, keep it in queue
    case suspended([Move])
    
    /// Partially resolved, replace it with child effects
    case resolving([Effect])
}
