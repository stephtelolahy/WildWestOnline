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
        priority: Int = 0,
        prototype: Card? = nil,
        silent: [String] = [],
        attributes: [String: Int] = [:],
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
    }

    func withPriority(_ value: Int) -> Self {
        .init(
            name: name,
            priority: value,
            attributes: attributes,
            rules: rules
        )
    }
}
