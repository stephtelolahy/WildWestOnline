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
        attributes: Attributes = [:],
        @CardRuleBuilder content: () -> [CardRule] = { [] }
    ) {
        self.name = name
        self.attributes = attributes
        self.rules = content()
            .reduce(into: [PlayReq: CardEffect]()) { result, rule in
                result[rule.playReq] = rule.effect
            }
    }

    init(
        _ name: String,
        attributes: Attributes = [:],
        prototype: Card
    ) {
        self.name = name
        self.attributes = attributes
        self.rules = prototype.rules
    }
}
