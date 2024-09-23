//
//  GameAction+IsEffect.swift
//
//
//  Created by Hugues Telolahy on 22/09/2023.
//

extension GameAction {
    func isEffectTriggeredBy(_ player: String) -> Bool {
        /*
        if case let .prepareEffect(_, ctx) = self,
           ctx.sourceActor == player {
            true
        } else {
            false
        }
         */
        false
    }

    func isEffectOfStartTurn(ignoredCard: String) -> Bool {
        /*
        if case let .prepareEffect(_, ctx) = self,
           case .startTurn = ctx.sourceEvent,
           ctx.sourceCard != ignoredCard {
            true
        } else {
            false
        }
         */
        false
    }

    func isEffectOfShoot(_ target: String) -> Bool {
        /*
        if case let .prepareEffect(effect, ctx: effectCtx) = self,
           case .prepareShoot = effect,
            effectCtx.resolvingTarget == target {
            return true
        } else {
            return false
        }
         */
        false
    }

    public func isEffectTargeting(_ player: String) -> Bool {
        /*
        if case .prepareEffect(_, let ctx) = self,
           ctx.resolvingTarget == player {
            return true
        } else {
            return false
        }
         */
        false
    }
}
