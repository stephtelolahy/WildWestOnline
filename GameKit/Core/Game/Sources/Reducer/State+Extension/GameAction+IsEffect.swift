//
//  GameAction+IsEffect.swift
//
//
//  Created by Hugues Telolahy on 22/09/2023.
//

extension GameAction {
    func isEffectTriggeredBy(_ player: String) -> Bool {
        if case let .effect(_, ctx) = self,
           ctx.sourceActor == player {
            true
        } else {
            false
        }
    }

    func isEffectOfSetTurn(ignoredCard: String) -> Bool {
        if case let .effect(_, ctx) = self,
           case .setTurn = ctx.sourceEvent,
           ctx.sourceCard != ignoredCard {
            true
        } else {
            false
        }
    }

    func isEffectOfShoot(_ player: String) -> Bool {
        #warning("damage is not enough to determine shoot effect")
        if case let .damage(_, target) = self,
           target == player {
            return true
        } else {
            return false
        }
    }
}
