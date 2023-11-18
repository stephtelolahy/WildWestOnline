//
//  CardEffect.swift
//  
//
//  Created by Hugues Telolahy on 30/04/2023.
//

/// Effect that can be applied to a player or a group of players
/// It applies to `EffectContext.target` if defined
/// By default it applies to `EffectContext.actor`
public indirect enum CardEffect: Codable, Equatable {
    // MARK: - Actions

    /// Restore player's health, limited to maxHealth
    case heal(Int)

    /// Deals damage to a player, attempting to reduce its Health by the stated amount
    case damage(Int)

    /// Shoot a player
    case shoot

    /// Draw top deck card
    case drawDeck

    /// Draw and top deck card, then apply effects according to card value
    case dackDeckReveal(String, onSuccess: Self)

    /// Discard a player's card to discard pile
    /// - `chooser` is the player that chooses card, by default `EffectContext.target`
    case discard(ArgCard, chooser: ArgPlayer? = nil)

    /// Draw card from a player
    /// - `toPlayer` is the player that chooses and steals cards
    case steal(ArgCard, toPlayer: ArgPlayer = .actor)

    /// Pass inPlay card to another player
    /// - `toPlayer` is the player that receives the card
    case passInPlay(ArgCard, toPlayer: ArgPlayer)

    /// Choose card from a location
    case chooseCard(ArgCard)

    /// Draw a card from deck and put to arena
    case discover

    /// Put back arena card to deck
    case putArenaToDeck

    /// Put top deck card to discard
    case putTopDeckToDiscard

    /// Set turn
    case setTurn

    /// Eliminate a player from the game
    case eliminate

    /// Evaluate all player attributes
    case updateAttributes

    /// Do nothing
    case nothing

    // MARK: - Operators

    /// Repeat an effect
    case `repeat`(ArgNum, effect: Self)

    /// Dispatch effects sequentially
    case group([Self])

    /// Apply an effect to targeted player(s)
    case target(ArgPlayer, effect: Self)

    /// Try an effect. If cannot, then apply some effect
    case force(Self, otherwise: Self)

    /// Force two players to perform an effect repeatedly. If cannot, then apply some effect
    case challenge(ArgPlayer, effect: Self, otherwise: Self)

    /// Try an effect. If cannot, then do nothing
    case ignoreError(Self)

    /// Flip over the top card of the deck, then apply effects according to card value
    case luck(ArgCardLuck, regex: String, onSuccess: Self, onFailure: Self? = nil)

    /// Counter shoot effect
    case counterShoot

    /// Cancel turn
    case cancelTurn

    /// Expose a choice to play counter cards
    case activateCounterCards
}
