//
//  CardLocation.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
import InitMacro

/// Card zone
@Init(defaults: ["cards": [], "hidden": false])
public struct CardLocation: Codable, Equatable {
    /// Content
    public var cards: [String]

    /// Cards are hidden for other players except the owner
    public let hidden: Bool
}

public extension CardLocation {
    /// Number of cards in the location
    var count: Int { cards.count }
}
