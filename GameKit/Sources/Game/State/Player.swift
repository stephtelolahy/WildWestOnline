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
    public var name: String = String()

    /// Initial attributes
    public var startAttributes: Attributes = [:]

    /// Active attributes
    public var attributes: Attributes = [:]

    /// Active abilities
    public var abilities: [String] = []

    /// Life points
    public var health: Int = 0

    /// Hand cards
    public var hand: CardLocation = .init()

    /// In play cards
    public var inPlay: CardLocation = .init()
}
