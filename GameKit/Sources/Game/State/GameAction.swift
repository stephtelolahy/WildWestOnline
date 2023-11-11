//
//  GameAction.swift
//  
//
//  Created by Hugues Telolahy on 06/04/2023.
//
import Redux

/// Game action
/// Triggered by user or by the system, that causes any update to the game state
public indirect enum GameAction: Action, Codable, Equatable {

    // MARK: - Play

    /// Play a brown card, discard immediately
    case playImmediate(String, target: String? = nil, player: String)

    /// Invoke an ability
    case playAbility(String, player: String)

    /// Put in play an equipment card
    case playEquipment(String, player: String)

    /// Play an handicap card
    case playHandicap(String, target: String, player: String)

    // MARK: - Renderable actions
    
    /// Restore player's health, limited to maxHealth
    case heal(Int, player: String)

    /// Deals damage to a player, attempting to reduce its Health by the stated amount
    case damage(Int, player: String)

    /// Draw top deck card
    case draw(player: String)

    /// Discard a player's hand card
    case discardHand(String, player: String)

    /// Discard a player's inPlay card
    case discardInPlay(String, player: String)
    
    /// Draw card from other player's hand
    case stealHand(String, target: String, player: String)
    
    /// Draw card from other player's inPlay
    case stealInPlay(String, target: String, player: String)

    /// Pass inPlay card to another player
    case passInplay(String, target: String, player: String)

    /// Draw some cards from arena
    case chooseArena(String, player: String)

    /// Draw a card from deck and put to arena
    case discover

    /// Set turn
    case setTurn(String)

    /// Eliminate
    case eliminate(player: String)

    /// Set player attribute
    case setAttribute(String, value: Int, player: String)
    
    /// Draw a card from deck and put to discard
    case luck

    /// Reveal a drawn card
    case reveal(String, player: String)

    /// Cancel a queued effect
    case cancel(Self)

    /// Expose a choice
    case chooseOne(player: String, options: [String: Self])

    /// Expose active cards
    case activateCards(player: String, cards: [String])

    /// End game
    case setGameOver(winner: String?)

    // MARK: - Invisible actions

    /// Resolve playing a card
    case play(String, player: String)

    /// Resolve an effect
    case effect(CardEffect, ctx: EffectContext)

    /// Push actions in queue
    case group([Self])
}

// MARK: - Convenience

public extension GameAction {

    /// Checking if action is renderable
    var isRenderable: Bool {
        switch self {
        case .play,
             .effect,
             .group:
            false

        default:
            true
        }
    }
}
