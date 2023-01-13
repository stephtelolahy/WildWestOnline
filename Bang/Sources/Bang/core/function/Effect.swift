//
//  Effect.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 09/12/2022.
//

/// Elementary card effect
public protocol Effect {
    
    func resolve(_ ctx: Game) -> Result<EffectOutput, GameError>
}

/// Resolving an effect may update game or push another effects
public protocol EffectOutput {
    
    /// Updated `State`
    var state: Game? { get }
    
    /// Resolving effect arguments, by pushing child effects
    var effects: [Effect]? { get }
    
    /// Suspended queue waiting user action
    var options: [Effect]? { get }
}
