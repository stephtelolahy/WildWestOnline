//
//  Player+Extension.swift
//
//
//  Created by Hugues Telolahy on 15/04/2023.
//

extension Player {
    var isDamaged: Bool {
        health < maxHealth
    }

    var handLimitAtEndOfTurn: Int {
        attributes[.handLimit] ?? health
    }

    mutating func gainHealth(_ value: Int) throws {
        guard health < maxHealth else {
            throw GameError.playerAlreadyMaxHealth(id)
        }

        let newHealth = min(health + value, maxHealth)
        health = newHealth
    }

    mutating func looseHealth(_ value: Int) {
        health -= value
    }

    mutating func setValue(_ value: Int?, forAttribute key: AttributeKey) {
        attributes[key] = value
    }
}

private extension Player {
    private var maxHealth: Int {
        attributes.get(.maxHealth)
    }
}
