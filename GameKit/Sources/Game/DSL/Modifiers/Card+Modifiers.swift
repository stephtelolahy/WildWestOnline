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
        attributes: [String: Int] = [:],
        @CardRuleBuilder content: () -> [CardRule] = { [] }
    ) {
        self.name = name
        self.priority = priority
        self.attributes = (prototype?.attributes ?? [:]).merging(attributes) { _, new in new }
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
