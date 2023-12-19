//
//  EffectForce.swift
//
//
//  Created by Hugues Telolahy on 13/05/2023.
//

struct EffectForce: EffectResolver {
    let effect: CardEffect
    let otherwise: CardEffect

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        do {
            let children = try effect.resolve(state: state, ctx: ctx)

            guard children.count == 1 else {
                fatalError("unexpected")
            }

            let action = children[0]
            switch action {
            case let .effect(childEffect, childCtx):
                return [.effect(.force(childEffect, otherwise: otherwise), ctx: childCtx)]

            case let .chooseOne(options, player):
                var options = options
                options[.pass] = .effect(otherwise, ctx: ctx)
                let chooseOne = try GameAction.validateChooseOne(chooser: player, options: options, state: state)
                return [chooseOne]

            default:

                // verify action, if succeed then return it
                _ = try action.reduce(state: state)
                return [action]
            }
        } catch {
            return [.effect(otherwise, ctx: ctx)]
        }
    }
}
