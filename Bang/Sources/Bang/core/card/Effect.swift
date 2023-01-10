//
//  Effect.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 09/12/2022.
//

/// Elementary card effect
public indirect enum Effect: Codable, Equatable {
    
    /// Deals damage to a character, attempting to reduce its Health by the stated amount
    case damage(player: ArgPlayer, value: Int)
    
    /// Restore character's health, limited to maxHealth
    case heal(player: ArgPlayer, value: Int)
    
    /// draw a card from top deck
    case draw(player: ArgPlayer)
    
    /// discard player's card to discard pile
    case discard(player: ArgPlayer, card: ArgCard)
    
    /// Player must discard a specific card. If cannot, then apply some effects
    case forceDiscard(player: ArgPlayer, card: ArgCard, otherwise: Effect)
    
    /// Player must discard a specific card. If cannot, then apply some effects
    case challengeDiscard(player: ArgPlayer, card: ArgCard, otherwise: Effect, challenger: ArgPlayer)
    
    /// Draw card from deck to store zone
    case store
    
    /// Choose some cards from store zone
    case choose(player: ArgPlayer, card: ArgCard)
    
    /// Set  phase
    case setPhase(value: Int)
    
    /// Set turn
    case setTurn(player: ArgPlayer)
    
    /// draw some cards from other player
    case steal(player: ArgPlayer, target: ArgPlayer, card: ArgCard)
    
    /// Repeat an effect
    case loop(times: ArgNumber, effect: Effect)
    
    /// Apply an effect to a group of players
    case apply(player: ArgPlayer, effect: Effect)
}
