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
        attributes: [String: Int] = [:],
        silent: [String] = [],
        alias: [CardAlias] = [],
        priority: Int = 0,
        @CardRuleBuilder content: () -> [CardRule] = { [] }
    ) {
        self.name = name
        self.priority = priority
        var attributes = (prototype?.attributes ?? [:]).merging(attributes) { _, new in new }
        for attr in silent {
            attributes.removeValue(forKey: attr)
        }
        self.attributes = attributes
        self.rules = (prototype?.rules ?? []) + content()
        self.alias = alias
    }

    func withPriority(_ value: Int) -> Self {
        .init(
            name: name,
            attributes: attributes,
            alias: alias,
            priority: value,
            rules: rules
        )
    }
}
