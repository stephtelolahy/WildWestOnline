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

    func resolve(state: GameState, ctx: EffectContext) throws -> EffectOutput {
        do {
            let children = try effect.resolve(state: state, ctx: ctx)

            switch children {
            case .nothing:
                return .push([.effect(otherwise, ctx: ctx)])

            case .push(let children):
                return try resolvePushChildren(children, state: state)

            default:
                fatalError("unexpected")
            }
        } catch {
            return .push([.effect(otherwise, ctx: ctx)])
        }
    }

    private func resolvePushChildren(_ children: [GameAction], state: GameState) throws -> EffectOutput {
        assert(children.isNotEmpty)
        if children.count == 1 {
            let action = children[0]
            switch action {
            case .drawDiscard:
                // drawing from discard may fail if empty
                // pre-verify action, if succeed then return it
                _ = try GameState.reducer(state, action)
                return .push([action])

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
                return .push([chooseOne, match])
            } else {
                fatalError("unexpected")
            }
        } else {
            fatalError("unexpected")
        }
    }
}
