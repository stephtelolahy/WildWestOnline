//
//  EffectResolver.swift
//  
//
//  Created by Hugues Telolahy on 09/01/2023.
//

/// Some  event that can be resolved
public protocol EffectResolver {
    
    /// Resolving an effect will update game and may result in another effects
    func resolve(_ effect: Effect, ctx: Game) -> Result<EffectOutput, GameError>
}

public protocol EffectOutput {
    
    /// Resolved with an updated `State`
    var state: Game? { get }
    
    /// Resolving arguments, replace it with child effects by transmitting context data
    var effects: [Effect]? { get }
}
