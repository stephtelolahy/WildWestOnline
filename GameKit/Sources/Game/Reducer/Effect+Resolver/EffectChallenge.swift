//
//  EffectChallenge.swift
//
//
//  Created by Hugues Telolahy on 13/05/2023.
//

struct EffectChallenge: EffectResolverProtocol {
    let challenger: PlayerArg
    let effect: CardEffect
    let otherwise: CardEffect
    
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let target = ctx.get(.target)
        
        guard case let .id(challengerId) = challenger else {
            return try challenger.resolve(state: state, ctx: ctx) {
                .effect(.challenge(.id($0),
                                   effect: effect,
                                   otherwise: otherwise),
                        ctx: ctx)
            }
        }
        
        do {
            let children = try effect.resolve(state: state, ctx: ctx)
            
            guard children.count == 1 else {
                fatalError("unexpected")
            }
            
            let action = children[0]
            switch action {
            case let .effect(childEffect, childCtx):
                return [.effect(.challenge(challenger,
                                           effect: childEffect,
                                           otherwise: otherwise),
                                ctx: childCtx)]
                
            case let .chooseOne(chooser, options):
                let reversedAction = GameAction.effect(.challenge(.id(target),
                                                                  effect: effect,
                                                                  otherwise: otherwise),
                                                       ctx: ctx.copy([.target: challengerId]))
                var options = options.mapValues { childAction in
                    GameAction.group {
                        childAction
                        reversedAction
                    }
                }
                options[.pass] = .effect(otherwise, ctx: ctx)
                let chooseOne = try GameAction.validateChooseOne(chooser: chooser, options: options, state: state)
                return [chooseOne]
                
            default:
                fatalError("unexpected")
            }
        } catch {
            let chooseOne = try GameAction.validateChooseOne(chooser: ctx.get(.target),
                                                             options: [.pass: .effect(otherwise, ctx: ctx)],
                                                             state: state)
            return [chooseOne]
        }
    }
}
