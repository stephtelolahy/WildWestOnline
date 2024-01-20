//
//  GameAction.swift
//  
//
//  Created by Hugues Telolahy on 06/04/2023.
//

import Redux
import Utils

/// Game action
/// Triggered by user or by the system, that causes any update to the game state
public indirect enum GameAction: Action, Codable, Equatable, DocumentConvertible {
    // MARK: - Renderable actions

    /// Play a card
    case play(String, player: String)

    /// Restore player's health, limited to maxHealth
    case heal(Int, player: String)

    /// Deals damage to a player, attempting to reduce its Health by the stated amount
    case damage(Int, player: String)

    /// Draw top deck card
    case drawDeck(player: String)

    /// Draw card from other player's hand
    case drawHand(String, target: String, player: String)

    /// Draw card from other player's inPlay
    case drawInPlay(String, target: String, player: String)

    /// Draw cards from arena
    case drawArena(String, player: String)

    /// Draw top discard
    case drawDiscard(player: String)

    /// Discard a player's hand card
    case discardHand(String, player: String)

    /// Discard a player's inPlay card
    case discardInPlay(String, player: String)

    /// Discard just played hand card
    case discardPlayed(String, player: String)

    /// Put an equipment card on player's inPlay
    case equip(String, player: String)

    /// Put hand card on target's inPlay
    case handicap(String, target: String, player: String)

    /// Pass inPlay card on target's inPlay
    case passInPlay(String, target: String, player: String)

    /// Put back hand card to deck
    case putBack(String, player: String)

    /// Reveal hand card
    case revealHand(String, player: String)

    /// Draw a card from deck and put to arena
    case discover

    /// Reveal top deck card and put to discard
    case draw

    /// Set turn
    case setTurn(player: String)

    /// Eliminate
    case eliminate(player: String)

    /// Set player attribute
    case setAttribute(AttributeKey, value: Int, player: String)

    /// Remove player attribute
    case removeAttribute(AttributeKey, player: String)

    /// Cancel an effect
    @available(*, deprecated, message: "cancel effect of some kind instad of specific action")
    case cancel(Self)

    /// Expose a choice
    case chooseOne(ChoiceType, options: [String], player: String)

    /// Choose an option
    case choose(String, player: String)

    /// Expose active cards
    case activate([String], player: String)

    /// End game
    case setGameOver(winner: String)

    // MARK: - Invisible actions

    /// Resolve an effect
    case effect(CardEffect, ctx: EffectContext)

    /// Push actions
    case group([Self])
}

// MARK: - Convenience

public extension GameAction {
    /// Checking if action is renderable
    var isRenderable: Bool {
        switch self {
        case .effect,
             .group:
            false

        default:
            true
        }
    }
}
