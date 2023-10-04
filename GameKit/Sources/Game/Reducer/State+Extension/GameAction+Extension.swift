//
//  GameAction+Extension.swift
//
//
//  Created by Hugues Telolahy on 22/09/2023.
//

extension GameAction {
    func isEffectTriggeredByCardNamed(_ cardName: String) -> Bool {
        if case let .effect(_, ctx) = self,
           ctx.card == cardName {
            true
        } else {
            false
        }
    }

    func isEffectTriggeredByPlayer(_ player: String) -> Bool {
        if case let .effect(_, ctx) = self,
           ctx.actor == player {
            true
        } else {
            false
        }
    }
}
