//
//  GameAction.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 28/07/2024.
//

/// An action is some kind of change
/// Triggered by user or by the system, that causes any update to the game state
public enum GameAction: String, Codable {
    /// {actor} plays a {card}
    case play

    /// {target or actor} increase health by {amount}
    case heal

    /// {target or actor} decrease health by {amount}
    case damage

    /// {target or actor} draw the top deck card
    case drawDeck

    /// {target or actor} discard a {card}
    case discard

    /// {actor} discard silently a {card}
    case discardSilently

    /// {actor} steal a {card} from {target}
    case steal

    /// {actor} put a {card} on {target}'s inPlay
    case handicap

    /// {actor} shoot at {target}
    /// By default damage is 1
    /// By default required misses is 1
    case shoot

    /// {target or actor} counter a shot applied on himself
    case missed

    /// {target} choose a {card} from choosable cards
    case chooseCard

    /// {actor} equip with a {card}
    case equip

    /// {actor} passes his {card} to {target}'s inPlay
    case pass

    /// expose {amount} choosable cards from top deck
    case reveal

    /// draw card(s) from deck by expecting some suits
    case draw

    /// {actor} ends his turn
    case endTurn

    /// {target} starts his turn
    case startTurn

    /// {target} gets eliminated
    case eliminate

    /// {actor} reveals his last drawn card
    case revealLastDraw

    /// {actor} draws the last discarded card
    case drawDiscard

    // MARK: ``Reversible``applied when card is played and reversed when card is discarded

    /// {actor} set his {attribute} to {amount}
    case setAttribute

    /// {actor} increase his {attribute} by +1
    case incrementAttribute
}
