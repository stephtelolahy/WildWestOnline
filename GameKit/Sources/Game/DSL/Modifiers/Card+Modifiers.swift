//
//  Card+Modifiers.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

import Foundation

public extension Card {
    init(
        _ name: String,
        prototype: Card? = nil,
        abilities: Set<String> = [],
        attributes: [AttributeKey: Int] = [:],
        silent: [String] = [],
        alias: [CardAlias] = [],
        priority: Int = 0,
        @CardRuleBuilder content: () -> [CardRule] = { [] }
    ) {
        self.name = name
        self.priority = priority
        var abilities = (prototype?.abilities ?? []).union(abilities)
        for element in silent {
            abilities.remove(element)
        }
        self.abilities = abilities
        self.attributes = (prototype?.attributes ?? [:]).merging(attributes) { _, new in new }
        self.rules = (prototype?.rules ?? []) + content()
        self.abilityToPlayCardAs = alias
    }

    func withPriority(_ value: Int) -> Self {
        .init(
            name: name,
            abilities: abilities,
            attributes: attributes,
            abilityToPlayCardAs: abilityToPlayCardAs,
            priority: value,
            rules: rules
        )
    }
}
