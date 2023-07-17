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
                .resolve(.challenge(.id($0),
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
            case let .resolve(childEffect, childCtx):
                return [.resolve(.challenge(challenger,
                                            effect: childEffect,
                                            otherwise: otherwise),
                                 ctx: childCtx)]
                
            case let .chooseOne(chooser, options):
                let reversedAction = GameAction.resolve(.challenge(.id(target),
                                                                   effect: effect,
                                                                   otherwise: otherwise),
                                                        ctx: ctx.copy([.target: challengerId]))
                var options = options.mapValues { childAction in
                    GameAction.group {
                        childAction
                        reversedAction
                    }
                }
                options[.pass] = .resolve(otherwise, ctx: ctx)
                let chooseOne = try GameAction.validChooseOne(chooser: chooser, options: options, state: state)
                return [chooseOne]
                
            default:
                fatalError("unexpected")
            }
        } catch {
            let chooseOne = try GameAction.validChooseOne(chooser: ctx.get(.target),
                                                          options: [.pass: .resolve(otherwise, ctx: ctx)],
                                                          state: state)
            return [chooseOne]
        }
    }
}
