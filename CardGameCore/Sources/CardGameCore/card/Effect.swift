//
//  Effect.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 30/05/2022.
//

/// Effects are card abilities that update the game state
/// The process of resolving an efect is similar to a depth-first search
public protocol Effect: Event {
    func resolve(in state: State, ctx: PlayContext) -> Result<EffectOutput, Error>
}

public struct EffectOutput {
    
    /// Resolved with an updated `State`, remove it from queue
    var state: State?
    
    /// Resolving arguments, replace it with child effects
    /// Must transmit context to child effects
    var effects: [Effect]?
    
    /// Suspended waiting user decision among an array of `Move`, keep it in queue
    var decisions: [Move]?
    
    /// Remove first queued effect matching a predicate
    var cancel: ((Effect) -> Bool)?
    
    public init(state: State? = nil,
                effects: [Effect]? = nil,
                decisions: [Move]? = nil,
                cancel: ((Effect) -> Bool)? = nil) {
        self.state = state
        self.effects = effects
        self.decisions = decisions
        self.cancel = cancel
    }
}

/// All data about resolving an effect
/// It is transmitted during sequence resolution
// TODO: replace with plain dictionary
public class PlayContext {
    
    /// the player that played the card the effects belong to
    public let actor: String
    
    /// selected argument during effect resolution
    public var selectedArg: String?
    
    /// target player from previous effect
    public var target: String?
    
    public init(actor: String, selectedArg: String? = nil, target: String? = nil) {
        self.actor = actor
        self.selectedArg = selectedArg
        self.target = target
    }
}
