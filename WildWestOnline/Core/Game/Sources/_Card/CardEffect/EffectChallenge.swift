//
//  EffectChallenge.swift
//
//
//  Created by Hugues Telolahy on 13/05/2023.
//

struct EffectChallenge: EffectResolver {
    let challenger: ArgPlayer
    let effect: CardEffect
    let otherwise: CardEffect

    func resolve(state: GameState, ctx: EffectContext) throws -> EffectOutput {
        /*
        guard case let .id(challengerId) = challenger else {
            let children = try challenger.resolve(state: state, ctx: ctx) {
                .prepareAction(
                    .challenge(
                        .id($0),
                        effect: effect,
                        otherwise: otherwise
                    ),
                    ctx: ctx
                )
            }
            return .push(children)
        }

        do {
            let children = try effect.resolve(state: state, ctx: ctx)

            switch children {
            case .nothing:
                return .push([.prepareAction(otherwise, ctx: ctx)])

            case .push(let children):
                return try resolvePushChildren(
                    children,
                    state: state,
                    ctx: ctx,
                    challengerId: challengerId
                )

            default:
                fatalError("unexpected")
            }
        } catch {
            return .push([.prepareAction(otherwise, ctx: ctx)])
        }
    }

    private func resolvePushChildren(
        _ children: [GameAction],
        state: GameState,
        ctx: EffectContext,
        challengerId: String
    ) throws -> EffectOutput {
        if children.count == 2 {
            if case .chooseOne(let type, var options, let player) = children[0],
               case let .prepareAction(childEffect, childCtx) = children[1],
               case var .matchAction(actions) = childEffect {
                var contextWithReversedTarget = ctx
                let target = ctx.targetOrActor()
                contextWithReversedTarget.resolvingTarget = challengerId
                let reversedChallenge = GameAction.prepareAction(
                    .challenge(
                        .id(target),
                        effect: effect,
                        otherwise: otherwise
                    ),
                    ctx: contextWithReversedTarget
                )
                actions = actions.mapValues {
                    GameAction.queue([$0, reversedChallenge])
                }

                options.append(.pass)
                actions[.pass] = .prepareAction(otherwise, ctx: childCtx)

                let chooseOne = GameAction.chooseOne(
                    type,
                    options: options,
                    player: player
                )
                let match = GameAction.prepareAction(
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
         */
        fatalError()
    }
}