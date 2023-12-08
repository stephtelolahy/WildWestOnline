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

    /// Current abilities
    public var abilities: Set<String>

    /// Current attributes
    public var attributes: [AttributeKey: Int]

    /// Life points
    public var health: Int

    /// Hand cards
    public var hand: [String]

    /// In play cards
    public var inPlay: [String]
}
