//
//  Player+Modifiers.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

import Foundation

public extension Player {

    init(_ id: String = UUID().uuidString, @PlayerAttributeBuilder components: () -> [PlayerAttribute] = { [] }) {
        self.id = id
        attributes = [
            .health: 0,
            .maxHealth: 0,
            .weapon: 1,
            .starTurnCards: 2
        ]
        components().forEach { $0.update(player: &self) }
    }

    func name(_ value: String) -> Self {
        copy { $0.name = value }
    }

    func attribute(_ key: AttributeKey, _ value: Int) -> Self {
        copy { $0.attributes[key] = value }
    }
    
    func ability(_ value: String) -> Self {
        copy { $0.abilities.append(value) }
    }
}

private extension Player {
    func copy(closure: (inout Self) -> Void) -> Self {
        var copy = self
        closure(&copy)
        return copy
    }
}
