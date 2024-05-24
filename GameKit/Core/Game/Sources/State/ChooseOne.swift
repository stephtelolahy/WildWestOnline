//
//  ChooseOne.swift
//  
//
//  Created by Hugues Telolahy on 08/01/2024.
//

/// Choice request
public struct ChooseOne: Codable, Equatable {
    public let type: ChoiceType
    public let options: [String]
}

/// ChooseOne context
public enum ChoiceType: String, Codable, Equatable {
    case target
    case challenger
    case cardToDiscard
    case cardToPassInPlay
    case cardToSteal
    case cardToDraw
    case cardToPutBack
    case cardToPlayCounter
}

/// ChooseOne labels
public extension String {
    /// Hidden hand card
    static let hiddenHand = "hiddenHand"

    /// Pass when asked to do an action
    static let pass = "pass"
}
