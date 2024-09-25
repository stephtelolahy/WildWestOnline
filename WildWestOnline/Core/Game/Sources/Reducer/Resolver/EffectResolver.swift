//
//  EffectResolver.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 25/09/2024.
//

extension ResolvingEffect {
    func resolve(state: GameState) throws -> [GameAction] {
        if selectors.isEmpty {
            [try toAction()]
        } else {
            try toChildren(state: state)
                .map(GameAction.prepareEffect)
        }
    }
}

private extension ResolvingEffect {
    func toAction() throws -> GameAction {
        switch action {
        case .playBrown:
                .playBrown(card, player: actor)

        case .drawDeck:
                .drawDeck(player: actor)

        default:
                .queue([])
        }
    }

    func toChildren(state: GameState) throws -> [Self] {
        var effect = self
        let selector = effect.selectors.remove(at: 0)

        switch selector {
        case .repeat(let times):
            let number = try times.resolve(state: state, ctx: self)
            return Array(repeating: effect, count: number)

        default:
            return []
        }
    }
}
