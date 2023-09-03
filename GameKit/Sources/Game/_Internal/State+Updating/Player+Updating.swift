//
//  Player+Updating.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

extension Player {
    var isDamaged: Bool {
        health < maxHealth
    }

    mutating func gainHealth(_ value: Int) throws {
        guard health < maxHealth else {
            throw GameError.playerAlreadyMaxHealth(id)
        }
        
        let newHealth = min(health + value, maxHealth)
        attributes[.health] = newHealth
    }

    mutating func looseHealth(_ value: Int) {
        attributes[.health] = health - value
    }

    mutating func setValue(_ value: Int, forAttribute key: AttributeKey) {
        attributes[key] = value
    }

    private var health: Int {
        attributes[.health] ?? 0
    }

    private var maxHealth: Int {
        attributes[.maxHealth] ?? 0
    }
}
