//
//  Effect.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 09/12/2022.
//

/// Elementary card effect
public protocol Effect {
    
    func resolve(_ ctx: Game, playCtx: PlayContext) -> Result<EffectOutput, GameError>
}

/// Resolving an effect may update game or push another effects
public protocol EffectOutput {
    
    /// Updated `State`
    var state: Game? { get }
    
    /// Children `Effect` on resolving arguments
    var children: [EffectNode]? { get }
}

public protocol PlayContext {
    
    /// current actor
    var actor: String { get }
    
    /// played card
    var playedCard: Card { get }
    
    /// target
    var target: String? { get set }
}

/// Structure composing Effect with its Playcontext
public struct EffectNode {
    
    public let effect: Effect
    
    public let playCtx: PlayContext
}
