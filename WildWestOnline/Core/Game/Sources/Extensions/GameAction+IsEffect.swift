//
//  GameAction+IsEffect.swift
//
//
//  Created by Hugues Telolahy on 22/09/2023.
//

extension GameAction {
    func isEffectTriggeredBy(_ player: String) -> Bool {
        if case let .prepareEffect(effect) = self,
           effect.actor == player {
            true
        } else {
            false
        }
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

extension GameState {
    /*
    mutating func cancel(_ action: GameAction) {
        if let index = queue.firstIndex(of: action) {
            queue.remove(at: index)
            removeEffectsLinkedTo(action)
        }
    }

    mutating func removeEffectsLinkedTo(_ action: GameAction) {
        if case let .prepareEffect(effect, effectCtx) = action,
           case .prepareShoot = effect,
           let target = effectCtx.resolvingTarget {
            removeEffectsLinkedToShoot(target)
        }
    }

    mutating func removeEffectsLinkedToShoot(_ target: String) {
        queue.removeAll { item in
            if case let .prepareEffect(_, ctx) = item,
               ctx.sourceShoot == target {
                return true
            } else {
                return false
            }
        }
    }
 */
}
