//
//  Player+Update.swift
//
//
//  Created by Hugues Telolahy on 15/04/2023.
//

extension Player {
    mutating func setValue(_ value: Int?, forAttribute key: String) {
        attributes[key] = value
    }
}

private extension Player {
    private var maxHealth: Int {
        attributes.get(.maxHealth)
    }
}
