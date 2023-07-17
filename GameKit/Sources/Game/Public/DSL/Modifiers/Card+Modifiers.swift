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
        type: CardType = .immediate,
        @CardActionBuilder content: () -> [CardAction] = { [] }
    ) {
        self.name = name
        self.type = type
        self.actions = content()
    }
}
