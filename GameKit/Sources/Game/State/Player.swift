//
//  Player.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

import Foundation

/// Player who is playing in a game
public struct Player: Identifiable, Codable, Equatable {
    /// Unique identifier
    public let id: String

    /// Figure name
    /// Determine initial attributes
    public let figure: String

    /// Current attributes
    public var attributes: [String: Int]

    /// Life points
    public var health: Int

    /// Hand cards
    public var hand: CardLocation

    /// In play cards
    public var inPlay: CardLocation
}
