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
}

/*
/// Elementary card effect
public indirect enum Effect: Codable, Equatable {
    
    /// Deals damage to a character, attempting to reduce its Health by the stated amount
    case damage(player: ArgPlayer, value: Int)
    
    /// Discard player's card to discard pile
    case discard(player: ArgPlayer, card: ArgCard)
    
    /// Player must discard a specific card. If cannot, then apply some effects
    case forceDiscard(player: ArgPlayer, card: ArgCard, otherwise: Effect)
    
    /// Player must discard a specific card. If cannot, then apply some effects
    case challengeDiscard(player: ArgPlayer, card: ArgCard, otherwise: Effect, challenger: ArgPlayer)
    
    /// Draw card from deck to store zone
    case store
    
    /// Choose some cards from store zone
    case choose(player: ArgPlayer, card: ArgCard)
    
    /// Draw some cards from other player
    case steal(player: ArgPlayer, target: ArgPlayer, card: ArgCard)
    
    /// Set turn
    case setTurn(player: ArgPlayer)
    
    /// Repeat an effect
    case loop(times: ArgNumber, effect: Effect)
}
*/
