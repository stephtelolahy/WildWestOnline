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

    func isEffectOfCard(_ cardName: String) -> Bool {
        if case let .effect(_, ctx) = self,
           ctx.card.extractName() == cardName {
            true
        } else {
            false
        }
    }

    func isEffectOfShoot(_ player: String) -> Bool {
        if case let .damage(_, target) = self,
           target == player {
            true
        } else {
            false
        }
    }
}
