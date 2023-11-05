//
//  CardEffect.swift
//  
//
//  Created by Hugues Telolahy on 30/04/2023.
//

/// Effect that can be applied to a player or a group of players
public indirect enum CardEffect: Codable, Equatable {

    // MARK: - Actions

    /// Restore player's health, limited to maxHealth
    case heal(Int)
    
    /// Deals damage to a player, attempting to reduce its Health by the stated amount
    case damage(Int)
    
    /// Shoot a player
    case shoot

    /// Draw top deck card
    case draw
    
    /// Discard a player's card to discard pile
    /// - `chooser` is the player that chooses card, by default `ctx.target`
    case discard(ArgCard, chooser: ArgPlayer? = nil)
    
    /// Draw card from a player
    /// - `toPlayer` is the player that chooses and steals cards
    case steal(ArgCard, toPlayer: ArgPlayer)

    /// Pass inPlay card to another player
    /// - `toPlayer` is the player that receives the card
    case passInplay(ArgCard, toPlayer: ArgPlayer)

    /// Choose some cards from arena
    case chooseArena
    
    /// Draw a card from deck and put to arena
    case discover
    
    /// Set turn
    case setTurn

    /// Eliminate a player from the game
    case eliminate
    
    /// Evaluate all player attributes
    case evaluateAttributes

    /// Do nothing
    case nothing

    // MARK: - Operators

    /// Repeat an effect
    case `repeat`(ArgNum, effect: Self)
    
    /// Dispatch effects sequentially
    case group([Self])

    /// Require state condition
    case require(StateCondition, effect: Self)

    /// Apply an effect to targeted player(s)
    case target(ArgPlayer, effect: Self)

    /// Try an effect. If cannot, then apply some effect
    case force(Self, otherwise: Self)

    /// Force two players to perform an effect repeatedly. If cannot, then apply some effect
    case challenge(ArgPlayer, effect: Self, otherwise: Self)
    
    /// Flip over the top card of the deck, then apply effects according to suits and values
    case luck(String, onSuccess: Self, onFailure: Self? = nil)
    
    /// Cancel some queued effect
    case cancel(ArgCancel)

    /// Expose a choice to play a card
    case activate
}
