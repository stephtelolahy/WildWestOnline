//
//  EffectResolver.swift
//  
//
//  Created by Hugues Telolahy on 09/01/2023.
//

/// Some  event that can be resolved
public protocol EffectResolver {
    
    /// Resolving an effect
    /// may update game or push another effects
    func resolve(_ effect: Effect, ctx: Game) -> Result<EffectOutput, GameError>
}

public protocol EffectOutput {
    
    /// Resolved successfully with an updated `State`
    var state: Game? { get }
    
    /// Resolving effect arguments, by pushing child effects
    var effects: [Effect]? { get }
}
