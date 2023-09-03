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
    }
}
