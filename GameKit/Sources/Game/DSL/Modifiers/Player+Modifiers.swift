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
        components().forEach { $0.apply(to: &self) }
    }

    func name(_ value: String) -> Self {
        copy { $0.name = value }
    }

    func attribute(_ key: AttributeKey, _ value: Int) -> Self {
        copy { $0.attributes[key] = value }
    }

    func setupAttribute(_ key: AttributeKey, _ value: Int) -> Self {
        copy { $0.startAttributes[key] = value }
    }

    func health(_ value: Int) -> Self {
        copy { $0.health = value }
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
