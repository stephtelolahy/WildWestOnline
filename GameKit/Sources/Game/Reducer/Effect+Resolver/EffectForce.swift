//
//  EffectForce.swift
//
//
//  Created by Hugues Telolahy on 13/05/2023.
//
// swiftlint:disable no_magic_numbers

struct EffectForce: EffectResolver {
    let effect: CardEffect
    let otherwise: CardEffect

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        do {
            let children = try effect.resolve(state: state, ctx: ctx)

            if children.count == 1 {
                let action = children[0]
                switch action {
                case let .effect(childEffect, childCtx):
//                    return [.effect(.force(childEffect, otherwise: otherwise), ctx: childCtx)]
                    fatalError("unexpected")

                case .drawDiscard:
                    // verify action, if succeed then return it
                    _ = try action.reduce(state: state)
                    return [action]

                default:
                    fatalError("unexpected")
                }
            } else if children.count == 2 {
                if case .chooseOne(let type, var options, let player) = children[0],
                   case let .effect(childEffect, childCtx) = children[1],
                   case var .matchAction(actions) = childEffect {
                    options.append(.pass)
                    actions[.pass] = .effect(otherwise, ctx: childCtx)
                    let chooseOne = GameAction.chooseOne(
                        type,
                        options: options,
                        player: player
                    )
                    let match = GameAction.effect(
                        .matchAction(actions),
                        ctx: childCtx
                    )
                    return [chooseOne, match]
                } else {
                    fatalError("unexpected")
                }
            } else {
                fatalError("unexpected")
            }
        } catch {
            return [.effect(otherwise, ctx: ctx)]
        }
    }
}
