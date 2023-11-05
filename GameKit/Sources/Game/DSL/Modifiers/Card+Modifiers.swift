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
        @CardRuleBuilder content: () -> [CardRule] = { [] }
    ) {
        self.name = name
        self.attributes = attributes
        self.rules = content()
    }

    init(
        _ name: String,
        attributes: [AttributeKey: Int] = [:],
        prototype: Card,
        @CardRuleBuilder content: () -> [CardRule] = { [] }
    ) {
        self.name = name
        self.attributes = attributes
        self.rules = prototype.rules + content()
    }
}
