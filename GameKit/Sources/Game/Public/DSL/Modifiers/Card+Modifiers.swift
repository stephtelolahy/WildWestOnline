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
        @CardRuleBuilder content: () -> [CardRule] = { [] }
    ) {
        self.name = name
        self.actions = content().toActions()
    }
}

public struct CardRule {
    let eventReq: EventReq
    let effect: CardEffect
    let playReqs: [PlayReq]
}

private extension Array where Element == CardRule {
    func toActions() -> [EventReq: CardAction] {
        reduce(into: [EventReq: CardAction]()) {
            $0[$1.eventReq] = CardAction(effect: $1.effect, playReqs: $1.playReqs)
        }
    }
}
