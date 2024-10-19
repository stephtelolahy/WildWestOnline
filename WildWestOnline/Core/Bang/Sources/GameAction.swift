//
//  GameAction.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 20/10/2024.
//
// swiftlint:disable discouraged_optional_collection

import Redux

/// Game action
/// Triggered by user or by the system, that causes any update to the game state
public struct GameAction: Action, Codable, Equatable {
    public let type: ActionType
    public let payload: ActionPayload
}

public enum ActionType: String, Codable {
    // MARK: - Renderable

    /// Discard just played hand card
    case playBrown

    /// Put an equipment card on player's inPlay
    case playEquipment

    /// Put hand card on target's inPlay
    case playHandicap

    /// Spell character ability
    case playAbility

    /// Restore player's health, limited to maxHealth
    case heal

    /// Deals damage to a player, attempting to reduce its Health by the stated amount
    case damage

    /// Draw top deck card
    case drawDeck

    /// Draw top discard
    case drawDiscard

    /// Draw card from other player's hand or inPlay
    case steal

    /// Discard a player's hand or inPlay card
    case discard

    /// Pass inPlay card on target's inPlay
    case passInPlay

    /// Flip top deck card and put to discard
    case draw

    /// Show hand card
    case showLastHand

    /// Discover top N deck cards
    case discover

    /// Draw discovered deck card
    case drawDiscovered

    /// Hide discovered cards
    case undiscover

    /// Start turn
    case startTurn

    /// End turn
    case endTurn

    /// Eliminate
    case eliminate

    /// Set attribute weapon
    case setWeapon

    /// Set attribute magnifying
    case setMaginifying

    /// Set attribute remoteness
    case setRemoteness

    // MARK: - To spec

    /// {actor} shoot at {target} with {damage} and {requiredMisses}
    /// By default damage is 1
    /// By default requiredMisses is 1
    case shoot

    /// {actor} counter a shot applied on himself
    case missed

    /// Counter card effect targetting self
    case counter

    /// End game
    case endGame

    /// Expose a choice
    case chooseOne

    /// Expose active cards
    case activate

    /// Move: play a card
    case preparePlay

    /// Move: choose an option
    case prepareChoose

    /// Resolve a pending action
    case prepareAction

    /// Queue actions
    case queue
}

public struct ActionPayload: Equatable, Codable {
    public let actor: String
    public var target: String?
    public var card: String?
    public var amount: Int?
    public var source: ActionSource?
    public var selectors: [TriggeredAbility.Selector]?
}

public struct ActionSource: Equatable, Codable {
    public let card: String
    public let actor: String
}

// MARK: - Convenience

public extension GameAction {
    var isRenderable: Bool {
        switch type {
        case .preparePlay,
             .prepareChoose,
             .prepareAction,
             .queue:
            false

        default:
            true
        }
    }
}
