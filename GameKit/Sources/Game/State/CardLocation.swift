//
//  CardLocation.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//
import InitMacro

/// Card zone
@Init(defaults: ["visibility": nil])
public struct CardLocation: Codable, Equatable {

    /// Content
    public var cards: [String]

    /// If defined, specifies player who has access to content
    public let visibility: String?
}

public extension CardLocation {
    /// Number of cards in the location
    var count: Int { cards.count }
}
