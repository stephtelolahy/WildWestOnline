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
    // MARK: - Play

    /// Play a brown card, discard immediately
    case playImmediate(String, target: String? = nil, player: String)

    /// Play a brown card as another card's effect, discard immediately
    case playAs(String, card: String, target: String? = nil, player: String)

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
    case drawDeck(player: String)

    /// Draw top deck card revealing it
    case drawDeckRevealing(player: String)

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

    /// Reveal hand card
    case revealHand(String, player: String)

    /// Pass inPlay card to another player
    case passInPlay(String, target: String, player: String)

    /// Draw a card from deck and put to arena
    case discover

    /// Put back arena card to deck
    case putBack

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
    case cancel(Self)

    /// Expose a choice
    case chooseOne([String: Self], player: String)

    /// Expose active cards
    case activate([String], player: String)

    /// End game
    case setGameOver(winner: String)

    // MARK: - Invisible actions

    /// Resolve playing a card
    case play(String, player: String)

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
        case .play,
             .effect,
             .group:
            false

        default:
            true
        }
    }
}
