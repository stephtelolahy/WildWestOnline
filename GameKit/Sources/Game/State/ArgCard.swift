//
//  ArgCard.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

/// Card argument
public enum ArgCard: Codable, Equatable {
    /// Card identified by
    case id(String)

    /// All cards
    case all

    /// Played card
    case played

    /// InPlay card with given attribute
    case previousInPlayWithAttribute(AttributeKey)

    /// Random hand card
    case randomHand

    /// Select any player's hand or inPlay card
    case selectAny

    /// Select any player's hand card
    case selectHand

    /// Select one of last N player's hand card
    case selectLastHand(Int)

    /// Select any arena card
    case selectArena

    /// Select any self's hand card matching given name
    case selectHandNamed(String)
}
