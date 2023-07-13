//
//  Player.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

import Foundation

/// Player who is playing in a game
public struct Player: GameElement, Identifiable, Codable, Equatable {

    /// Unique identifier
    public let id: String

    /// Display name
    public var name: String = String()
    
    /// Player specific attributes
    public var attributes: Attributes = [:]

    /// Player specific abilities
    public var abilities: [String] = []

    /// Hand cards
    public var hand: CardLocation = .init()

    /// In play cards
    public var inPlay: CardLocation = .init()
}
