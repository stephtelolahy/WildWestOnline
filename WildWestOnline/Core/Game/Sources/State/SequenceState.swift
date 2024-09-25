//
//  SequenceState.swift
//
//
//  Created by Hugues Telolahy on 06/07/2024.
//

public struct SequenceState: Codable, Equatable {
    /// Queued effects
    public var queue: [GameAction]

    /// Pending action by player
    public var chooseOne: [String: ChooseOne]

    /// Playable cards by player
    public var active: [String: [String]]

    /// Current turn's number of times a card was played
    public var played: [String: Int]

    /// Game over
    public var winner: String?
}

/// Context data associated to an effect
public struct EffectContext: Codable, Equatable {
    /// Occurred event triggering the effect
    let sourceEvent: GameAction

    /// Owner of the card triggering the effect
    let sourceActor: String

    /// Card triggering the effect
    let sourceCard: String

    /// Targeted player while resolving the effect
    var resolvingTarget: String?

    /// Chooser player while resolving the effect
    var resolvingChooser: String?

    /// Chosen option while resolving effect
    var resolvingOption: String?
}

public extension EffectContext {
    /// Shot player triggering this effect
    /// The cancelation of the shoot results in the cancelation of the effect
    var sourceShoot: String? {
        /*
        guard case let .prepareEffect(cardEffect, ctx) = sourceEvent,
              case .shoot = cardEffect else {
            return nil
        }

        return ctx.resolvingTarget
         */
        nil
    }
}

/// Choice request
public struct ChooseOne: Codable, Equatable {
    public let type: ChoiceType
    public let options: [String]
}

/// ChooseOne context
@available(*, deprecated, renamed: "ActionType")
public enum ChoiceType: String, Codable, Equatable {
    case target
    case cardToDraw
    case cardToSteal
    case cardToDiscard
    case cardToPassInPlay
    case cardToPutBack
    case cardToPlayCounter
}

/// ChooseOne options
public extension String {
    /// Hidden hand card
    static let hiddenHand = "hiddenHand"

    /// Pass when asked to do an action
    static let pass = "pass"
}

public extension SequenceState {
    enum Error: Swift.Error, Equatable {
        /// Expected game to be active
        case gameIsOver

        /// Expected to choose one of waited action
        case unwaitedAction

        /// Expected card to have play rule
        case cardNotPlayable(String)

        /// No shoot effect to counter
        case noShootToCounter
    }
}
