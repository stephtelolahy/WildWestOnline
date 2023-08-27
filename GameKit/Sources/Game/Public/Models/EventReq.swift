//
//  EventReq.swift
//
//
//  Created by Hugues Telolahy on 03/06/2023.
//

/// Function defining occurred event to play a card
public enum EventReq: Codable, Equatable, Hashable {

    /// After playing a card
    case onPlay(PlayMode)

    /// After setting turn
    case onSetTurn

    /// After loosing last life point
    case onLooseLastHealth

    /// After being eliminated
    case onEliminated

    /// After being forced to discard hand card named X
    case onForceDiscardHandNamed(String)
}

/// Decsribing the manner a card is played
public enum PlayMode: String, Codable, CodingKeyRepresentable {

    /// The card has effects that are resolved immediately, and then the card is discarded
    case immediate

    /// The card has effects that are resolved immediately
    case ability

    /// Equipment card, put in self's play
    case equipment

    /// Handicap card, put in target's play
    case handicap
}
