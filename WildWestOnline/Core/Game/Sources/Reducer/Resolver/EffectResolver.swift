//
//  EffectResolver.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 25/09/2024.
//

extension ResolvingEffect {
    func resolve(state: GameState) throws -> [GameAction] {
        if selectors.isEmpty {
            let resolved = try action.resolve(self)
            return [resolved]
        } else {
            var effect = self
            let selector = effect.selectors.remove(at: 0)
            let resolved = try selector.resolve(state: state, ctx: effect)
            return resolved.map(GameAction.prepareEffect)
        }
    }
}
