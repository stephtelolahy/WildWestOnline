//
//  GameAction.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 28/07/2024.
//

/// An action is some kind of change
/// Triggered by user or by the system, that causes any update to the game state
public enum GameAction: String, Codable {
    /// {player} increase health by {amount}
    case heal

    /// {player} decrease health by {amount}
    case damage

    /// {player} draw top deck card
    case drawDeck

    /// {player} discard a {card}
    case discard

    /// {player} discard silently a {card}
    case discardSilently

    /// {actor} steal a {card} from {player}
    case steal

    /// {actor} put a {card} on {player}'s inPlay
    case handicap

    /// {actor} shoot at {player} with {requiredMisses}
    case shoot

    /// {player} counter a shot applyed on himself
    case counterShoot

    /// {player} choose a {card} from choosable cards
    case chooseCard

    /// {player} equip with his {card}
    case equip

    /// {actor} passes his {card} to {player}'s inPlay
    case passInPlay

    /// Expose {amount} choosable cards from top deck
    case reveal

    /// Draw card(s) from deck by expecting {regex}
    case draw

    /// {actor} sets weapon to {amount}
    case setWeapon

    /// {actor} sets unlimited bangs per turn
    case setUnlimitedBang

    /// {actor} decreases distance to others
    case increaseMagnifying

    /// {actor} increase distance from others
    case increaseRemoteness

    /// {actor} skip his turn
    case skipTurn

    /// {actor} ends his turn
    case endTurn

    /// {player} starts his turn
    case startTurn
}
