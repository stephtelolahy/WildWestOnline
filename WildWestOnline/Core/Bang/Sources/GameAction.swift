//
//  GameAction.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 28/07/2024.
//

/// An action is some kind of change that happens to an object.
public enum GameAction: String, Codable {
    /// {player} increase health by {amount}
    case heal

    /// {player} decrease health by {amount}
    case damage

    /// {player} draw top deck card
    case drawDeck

    /// {player} discard his {card}
    case discard

    /// {player} discard silently a played {card}
    case discardPlayed

    /// {actor} steal a {card} from {player}
    case steal

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

    /// Draw expecting {regex}
    case draw

    /// Set weapon to {amount} to {actor}
    case setWeapon

    /// Set unlimited bangs per turn to {actor}
    case setUnlimitedBang

//    case increaseMagnifying
//    case increaseRemoteness
//    case setTurn
}
