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
    
    /// Resolved successfully with an updated `State`
    var state: Game? { get }
    
    /// Resolving effect arguments, by pushing child effects
    var effects: [Effect]? { get }
    
    /// Suspended waiting user decision
    var options: [Effect]? { get }
}

/*
/// Elementary card effect
public indirect enum Effect: Codable, Equatable {
    
    /// Deals damage to a character, attempting to reduce its Health by the stated amount
    case damage(player: ArgPlayer, value: Int)
    
    /// Player must discard a specific card. If cannot, then apply some effects
    case forceDiscard(player: ArgPlayer, card: ArgCard, otherwise: Effect)
    
    /// Player must discard a specific card. If cannot, then apply some effects
    case challengeDiscard(player: ArgPlayer, card: ArgCard, otherwise: Effect, challenger: ArgPlayer)
}
*/
