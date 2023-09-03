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
        @CardActionBuilder content: () -> [CardAction] = { [] }
    ) {
        self.name = name
        self.actions = content().toActions()
    }
}

public struct CardAction {
    let eventReq: EventReq
    let effect: CardEffect
}

private extension Array where Element == CardAction {
    func toActions() -> [EventReq: CardEffect] {
        reduce(into: [EventReq: CardEffect]()) {
            $0[$1.eventReq] = $1.effect
        }
    }
}
