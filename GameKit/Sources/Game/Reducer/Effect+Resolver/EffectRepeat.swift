//
//  EffectRepeat.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

struct EffectRepeat: EffectResolverProtocol {
    let effect: CardEffect
    let times: ArgNum
    
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        let argNumContext = ArgNumContext(actor: ctx.get(.actor))
        let number = try times.resolve(state: state, ctx: argNumContext)
        return (0..<number).map { _ in
            .effect(effect, ctx: ctx)
        }
    }
}
