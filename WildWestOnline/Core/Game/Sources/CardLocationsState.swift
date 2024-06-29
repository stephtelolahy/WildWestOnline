//
//  CardLocationsState.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 29/06/2024.
//

public struct CardLocationsState: Equatable, Codable {
    /// Deck
    public var deck: [String]

    /// Discard pile
    public var discard: [String]

    /// Cards shop
    public var arena: [String]

    /// Hand cards
    public var hand: [String: [String]]

    /// In play cards
    public var inPlay: [String: [String]]
}
