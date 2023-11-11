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
        attributes: [AttributeKey: Int] = [:],
        prototype: Card? = nil,
        @CardRuleBuilder content: () -> [CardRule] = { [] }
    ) {
        self.name = name
        self.attributes = (prototype?.attributes ?? [:]).merging(attributes) { _, new in new }
        self.rules = (prototype?.rules ?? []) + content()
    }
}
