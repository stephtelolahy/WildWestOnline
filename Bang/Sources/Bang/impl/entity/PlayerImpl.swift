//
//  PlayerImpl.swift
//  
//
//  Created by Hugues Telolahy on 09/01/2023.
//

public struct PlayerImpl: Player {
    public var id: String
    public var name: String
    public var maxHealth: Int
    public var health: Int
    public var abilities: [Card]
    public var hand: [Card]
    public var inPlay: [Card]
    public var mustang: Int
    public var scope: Int
    
    public init(id: String = "",
                name: String = "",
                maxHealth: Int = 0,
                health: Int = 0,
                mustang: Int = 0,
                scope: Int = 0,
                abilities: [Card] = [],
                hand: [Card] = [],
                inPlay: [Card] = []) {
        self.id = id
        self.name = name
        self.maxHealth = maxHealth
        self.health = health
        self.mustang = mustang
        self.scope = scope
        self.abilities = abilities
        self.hand = hand
        self.inPlay = inPlay
    }
    
    public var handLimit: Int { health }

    public var weapon: Int { 1 }
}
