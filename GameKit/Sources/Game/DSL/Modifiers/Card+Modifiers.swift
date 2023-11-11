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
        @CardRuleBuilder content: () -> [CardRule] = { [] }
    ) {
        self.name = name
        self.attributes = (prototype?.attributes ?? [:]).merging(attributes) { _, new in new }
        self.rules = (prototype?.rules ?? []) + content()
    }
}
