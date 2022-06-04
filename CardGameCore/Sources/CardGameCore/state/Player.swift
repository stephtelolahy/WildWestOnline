//
//  Player.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 31/05/2022.
//

public struct Player {
    
    /// player name
    public let name: String
    
    /// max health
    public let maxHealth: Int
    
    /// current health
    public var health: Int
    
    /// built-in cards
    public var inner: [Card]
    
    /// hand cards
    public var hand: [Card]
    
    /// in play cards
    public var inPlay: [Card] = []
    
    public init(
        name: String = "",
        maxHealth: Int = 0,
        health: Int = 0,
        inner: [Card] = [],
        hand: [Card] = []
    ) {
        self.name = name
        self.maxHealth = maxHealth
        self.health = health
        self.inner = inner
        self.hand = hand
    }
}
