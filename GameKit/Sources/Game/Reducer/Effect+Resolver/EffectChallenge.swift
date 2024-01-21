//
//  EffectChallenge.swift
//
//
//  Created by Hugues Telolahy on 13/05/2023.
//
// swiftlint:disable no_magic_numbers

struct EffectChallenge: EffectResolver {
    let challenger: ArgPlayer
    let effect: CardEffect
    let otherwise: CardEffect

    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let target = ctx.targetOrActor()

        guard case let .id(challengerId) = challenger else {
            return try challenger.resolve(state: state, ctx: ctx) {
                .effect(
                    .challenge(
                        .id($0),
                        effect: effect,
                        otherwise: otherwise
                    ),
                    ctx: ctx
                )
            }
        }

        do {
            let children = try effect.resolve(state: state, ctx: ctx)

            if children.count == 2 {
                if case .chooseOne(let type, var options, let player) = children[0],
                   case let .effect(childEffect, childCtx) = children[1],
                   case var .matchAction(actions) = childEffect {
                    var contextWithReversedTarget = ctx
                    contextWithReversedTarget.target = challengerId
                    let reversedChallenge = GameAction.effect(
                        .challenge(
                            .id(target),
                            effect: effect,
                            otherwise: otherwise
                        ),
                        ctx: contextWithReversedTarget
                    )
                    actions = actions.mapValues {
                        GameAction.group([$0, reversedChallenge])
                    }

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
