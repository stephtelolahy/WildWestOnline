//
//  GameAction+Extension.swift
//
//
//  Created by Hugues Telolahy on 22/09/2023.
//

extension GameAction {
    func isEffectTriggeredBy(_ player: String) -> Bool {
        if case let .effect(_, ctx) = self,
           ctx.actor == player {
            true
        } else {
            false
        }
    }

    func isEffectOfSetTurn(ignoredCard: String) -> Bool {
        if case let .effect(_, ctx) = self,
           case .setTurn = ctx.event,
           ctx.card != ignoredCard {
            true
        } else {
            false
        }
    }

    @available(*, deprecated, message: "damage is not enough to determine shoot effect")
    func isEffectOfShoot(_ player: String) -> Bool {
        if case let .damage(_, target) = self,
           target == player {
            true
        } else {
            false
        }
    }
}
