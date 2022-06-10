//
//  Effect.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 30/05/2022.
//

/// Effects are card abilities that update the game state
/// The process of resolving an efect is similar to a depth-first search
public protocol Effect: Event {
    func resolve(state: State, ctx: PlayContext) -> EffectResult
}

public enum EffectResult {
    
    /// Resolved with an updated `State`, remove it from queue
    case success(State)
    
    /// Failed with an `Error`, remove it from queue
    /// Returned error must implement `Event` protocol
    case failure(Error)
    
    /// Partially resolved, replace it with child effects
    case resolving([Effect])
    
    /// Suspended waiting user decision among an array of `Move`, keep it in queue
    case suspended([String: [Move]])
    
    /// Remove first effect matching a predicate
    case remove((Effect) -> Bool, Error)
    
    /// Nothing happens, remove it from queue, do not mention it
    case nothing
}

/// All data about resolving an effect
/// It is transmitted during sequence resolution
public class PlayContext {
    
    /// the player that played the card the effects belong to
    public let actor: String
    
    /// selected argument during effect resolution
    public var selectedArg: String?
    
    /// target player from previous effect
    public var target: String?
    
    public init(actor: String, selectedArg: String? = nil) {
        self.actor = actor
        self.selectedArg = selectedArg
    }
}
