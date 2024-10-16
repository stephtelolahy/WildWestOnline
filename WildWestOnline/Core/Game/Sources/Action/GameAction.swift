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
    // MARK: - Renderable

    /// Discard just played hand card
    case playBrown(String, player: String)

    /// Put an equipment card on player's inPlay
    case playEquipment(String, player: String)

    /// Put hand card on target's inPlay
    case playHandicap(String, target: String, player: String)

    /// Spell character ability
    case playAbility(String, player: String)

    /// Restore player's health, limited to maxHealth
    case heal(Int, player: String)

    /// Deals damage to a player, attempting to reduce its Health by the stated amount
    case damage(Int, player: String)

    /// Draw top deck card
    case drawDeck(player: String)

    /// Draw specific deck card
    case drawDeckCard(String, player: String)

    /// Draw top discard
    case drawDiscard(player: String)

    /// Draw card from other player's hand
    case stealHand(String, target: String, player: String)

    /// Draw card from other player's inPlay
    case stealInPlay(String, target: String, player: String)

    /// Discard a player's hand card
    case discardHand(String, player: String)

    /// Discard a player's inPlay card
    case discardInPlay(String, player: String)

    /// Pass inPlay card on target's inPlay
    case passInPlay(String, target: String, player: String)

    /// Flip top deck card and put to discard
    case draw

    /// Show hand card
    case showHand(String, player: String)

    /// Start turn
    case startTurn(player: String)

    /// End turn
    case endTurn(player: String)

    /// Eliminate
    case eliminate(player: String)

    /// Set player attribute
    case setAttribute(String, value: Int?, player: String)

    /// End game
    case endGame(winner: String)

    /// Expose active cards
    case activate([String], player: String)

    /// Expose a choice
    case chooseOne(ChoiceType, options: [String], player: String)

    // MARK: - Invisible

    /// Move: play a card
    case preparePlay(String, player: String)

    /// Move: choose an option
    case prepareChoose(String, player: String)

    /// Resolve an effect
    case prepareEffect(CardEffect, ctx: EffectContext)

    /// Queue actions
    case queue([Self])

    // MARK: - Deprecated

    /// Discover deck card
    @available(*, deprecated, renamed: "discover")
    case discover

    /// Draw cards from arena
    @available(*, deprecated, renamed: "drawDeckCard")
    case drawArena(String, player: String)

    /// Put back hand card to deck
    @available(*, deprecated, renamed: "undiscover")
    case putBack(String, player: String)
}

// MARK: - Convenience

public extension GameAction {
    static let nothing: Self = .queue([])
}

public extension GameAction {
    /// Checking if action is renderable
    var isRenderable: Bool {
        switch self {
        case .preparePlay,
             .prepareChoose,
             .prepareEffect,
             .queue:
            false

        default:
            true
        }
    }
}
