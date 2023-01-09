//
//  Effect.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 09/12/2022.
//

/// Elementary card effect
public indirect enum Effect: Codable {
    
    /// Deals damage to a character, attempting to reduce its Health by the stated amount
    case damage(player: String, value: Int)
    
    /// Restore character's health, limited to maxHealth
    case heal(player: String, value: Int)
    
    /// draw a card from top deck
    case draw(player: String)
    
    /// discard player's card to discard pile
    case discard(player: String, card: String)
    
    /// Player must discard a specific card. If cannot, then apply some effects
    case forceDiscard(player: String, card: String, otherwise: Effect)
    
    /// Player must discard a specific card. If cannot, then apply some effects
    case challengeDiscard(player: String, card: String, challenger: String, otherwise: Effect)
    
    /// Draw card from deck to store zone
    case store
    
    /// Choose some cards from store zone
    case choose(player: String, card: String)
    
    /// Set  phase
    case setPhase(value: Int)
    
    /// Set turn
    case setTurn(player: String)
    
    /// draw some cards from other player
    case steal(player: String, target: String, card: String)
    
    /// Repeat an effect
    case loop(times: String, effect: Effect)
    
    /// Apply an effect to a group of players
    case apply(players: String, effect: Effect)
}

public protocol EffectResolving {
 
    /// Resolving an effect will update game and may result in another effects
    func resolve(ctx: Game) -> Result<[Effect], Error>
}
