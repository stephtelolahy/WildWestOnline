//
//  Args+Number.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 05/06/2022.
//

import CardGameCore

extension Args {
    
    static func resolveNumber<T: Effect>(
        _ number: String,
        copy: @escaping () -> T,
        ctx: [String: Any],
        state: State
    ) -> Result<EffectOutput, Error> {
        let value = resolveNumber(number, ctx: ctx, state: state)
        guard value > 0 else {
            return .success(EffectOutput())
        }
        
        let effects = (0..<value).map { _ in copy() }
        return .success(EffectOutput(effects: effects))
    }
    
    static func resolveNumber(_ number: String, ctx: [String: Any], state: State) -> Int {
        switch number {
        case .NUM_PLAYERS:
            return state.playOrder.count
            
        case .NUM_EXCESS_HAND:
            let actorObj = state.player(ctx.actor)
            return max(actorObj.hand.count - actorObj.handLimit, 0)
            
        default:
            guard let value = Int(number) else {
                fatalError(.invalidNumber(number))
            }
            
            return value
        }
    }
}
