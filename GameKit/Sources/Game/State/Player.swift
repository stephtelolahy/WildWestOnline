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

    /// Display name
    public let name: String

    /// Active abilities
    public let abilities: [String]

    /// Initial attributes
    public let startAttributes: [String: Int]

    /// Active attributes
    public var attributes: [String: Int]

    /// Life points
    public var health: Int

    /// Hand cards
    public var hand: CardLocation

    /// In play cards
    public var inPlay: CardLocation
}
