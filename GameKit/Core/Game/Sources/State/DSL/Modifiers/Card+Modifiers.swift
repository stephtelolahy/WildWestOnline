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
        @CardRuleBuilder rules: () -> [CardRule] = { [] }
    ) {
        self.name = name
        self.priority = priority
        self.abilities = (prototype?.abilities ?? []).union(abilities).filter { !silent.contains($0) }
        self.attributes = (prototype?.attributes ?? [:]).merging(attributes) { _, new in new }
        self.rules = (prototype?.rules ?? []) + rules()
        self.abilityToPlayCardAs = alias
    }

    func withPriority(_ value: Int) -> Self {
        .init(
            name: name,
            attributes: attributes,
            abilities: abilities,
            abilityToPlayCardAs: abilityToPlayCardAs,
            priority: value,
            rules: rules
        )
    }
}
