//
//  Effect.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 30/05/2022.
//
import Foundation

/// Effects are card abilities that update the game state
/// The process of resolving an efect is similar to a depth-first search
public protocol Effect: Event {
    
    var ctx: [String: Any] { get set }
    
    func resolve(in state: State) -> Result<EffectOutput, Error>
}

public struct EffectOutput {
    
    /// Resolved with an updated `State`, remove it from queue
    var state: State?
    
    /// Resolving arguments, replace it with child effects
    /// Must transmit context to child effects
    var effects: [Effect]?
    
    /// Suspended waiting user decision among an array of `Move`, keep it in queue
    var options: [Move]?
    
    public init(state: State? = nil,
                effects: [Effect]? = nil,
                options: [Move]? = nil) {
        assert(effects == nil || effects?.isEmpty == false)
        assert(options == nil || options?.isEmpty == false)
        
        self.state = state
        self.effects = effects
        self.options = options
    }
}
