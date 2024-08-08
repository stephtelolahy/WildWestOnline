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

    /// {player or actor} increase health by {amount}
    case heal

    /// {player or actor} decrease health by {amount}
    case damage

    /// {player or actor} draw the top deck card
    case drawDeck

    /// {player or actor} discard a {card}
    case discard

    /// {player or actor} discard silently a {card}
    case discardSilently

    /// {actor} steal a {card} from {player}
    case steal

    /// {actor} put a {card} on {player}'s inPlay
    case handicap

    /// {actor} shoot at {player}
    /// By default damage is 1
    /// By default required misses is 1
    case shoot

    /// {player or actor} counter a shot applyed on himself
    case missed

    /// {player} choose a {card} from choosable cards
    case chooseCard

    /// {actor} equip with a {card}
    case equip

    /// {actor} passes his {card} to {player}'s inPlay
    case pass

    /// expose {amount} choosable cards from top deck
    case reveal

    /// draw card(s) from deck by expecting some suits
    case draw

    /// {actor} ends his turn
    case endTurn

    /// {player} starts his turn
    case startTurn

    /// {player} get eliminated
    case eliminate

    /// {actor} reveals his last drawn card
    case revealLastDraw

    /// {actor} draws the last discarded card
    case drawDiscard

    /// {actor} set his {attribute} to {amount}
    case setAttribute

    /// {actor} increase his {attribute} by +1
    case incrementAttribute
}
