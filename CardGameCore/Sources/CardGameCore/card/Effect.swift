//
//  Effect.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 30/05/2022.
//

/// Effects are card abilities that update the game state
/// The process of resolving an efect is similar to a depth-first search
public protocol Effect: Event {
    func resolve(in state: State, ctx: [EffectKey: String]) -> Result<EffectOutput, Error>
}

public struct EffectOutput {
    
    /// Resolved with an updated `State`, remove it from queue
    var state: State?
    
    /// Resolving arguments, replace it with child effects
    /// Must transmit context to child effects
    var effects: [Effect]?
    
    /// Additional context data to transmit to child effects
    var childCtx: [EffectKey: String]?
    
    /// Suspended waiting user decision among an array of `Move`, keep it in queue
    var decisions: [Move]?
    
    /// Remove first queued effect matching a predicate
    var cancel: ((Effect) -> Bool)?
    
    public init(state: State? = nil,
                effects: [Effect]? = nil,
                childCtx: [EffectKey: String]? = nil,
                decisions: [Move]? = nil,
                cancel: ((Effect) -> Bool)? = nil) {
        self.state = state
        self.effects = effects
        self.childCtx = childCtx
        self.decisions = decisions
        self.cancel = cancel
    }
}

public enum EffectKey: String {
    
    /// who played the Move
    case ACTOR
    
    /// selected item during effect resolution
    case SELECTED
    
    /// previous effect's target
    case TARGET
}
