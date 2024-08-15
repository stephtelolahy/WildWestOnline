//
// Action.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 13/08/2024.
//

/// An action is some kind of change triggered by user or by the system, that causes any update to the game state
public enum Action: String, Codable {
    /// {actor} plays a {card}
    case play

    /// {actor} chooses an {option}
    case choose

    /// {target} increase health by {amount}
    /// By default target is {actor}
    /// By default heal amount is 1
    case heal

    /// {target} decrease health by {amount}
    /// By default target is {actor}
    /// By default damage amount is 1
    case damage

    /// {actor} draw the top deck card
    /// When a {card} is specified, this allow to draw a specific card
    case drawDeck

    /// {target} discard a {card}
    /// By default target is {actor}
    case discard

    /// {actor} discard silently a {card}
    case discardSilently

    /// {actor} steal a {card} from {target}
    case steal

    /// {actor} put a {card} is self's inPlay
    case equip

    /// {actor} put a {card} on {target}'s inPlay
    case handicap

    /// {actor} shoot at {target} with {damage} and {requiredMisses}
    /// By default damage is 1
    /// By default requiredMisses is 1
    case shoot

    /// {actor} counter a shot applied on himself
    case missed

    /// expose {amount} choosable cards from top deck
    case reveal

    /// draw {drawCards} cards from deck. Next effects depend on it
    case draw

    /// {actor} shows his last drawn card
    case showLastDraw

    /// {actor} ends his turn
    case endTurn

    /// {target} starts his turn
    case startTurn

    /// {actor} gets eliminated
    case eliminate

    /// {actor} draws the last discarded card
    /// When a {card} is specified, this allow to draw a specific card
    case drawDiscard

    /// set {actor}'s {attribute} to {value}
    case setAttribute

    /// increment {actor}'s {attribute} to {value}
    case incrementAttribute

    /// Arguments required for dispatching a specific action
    public enum Argument: String, Codable {
        case healAmount
        case damageAmount
        case repeatAmount
        case revealAmount
        case shootRequiredMisses
        case limitPerTurn
    }
}
