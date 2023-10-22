//
//  CardLocation.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

/// Card zone
public struct CardLocation: Codable, Equatable {

    /// Content
    public var cards: [String] = []

    /// If defined, specifies player who has access to content
    public var visibility: String?
}

public extension CardLocation {
    /// Number of cards in the location
    var count: Int { cards.count }
}
