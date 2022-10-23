//
//  Args+Number.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 05/06/2022.
//
// swiftlint:disable identifier_name

import CardGameCore

public extension String {
    
    /// Number of active players
    static let NUM_PLAYERS = "NUM_PLAYERS"
    
    /// Number of excess cards
    static let NUM_EXCESS_HAND = "NUM_EXCESS_HAND"
}

extension Args {
    
    static func resolveNumber<T: Effect>(
        _ number: String,
        copy: @escaping () -> T,
        ctx: [EffectKey: String],
        state: State
    ) -> Result<EffectOutput, Error> {
        let value = resolveNumber(number, ctx: ctx, state: state)
        let effects = (0..<value).map { _ in copy() }
        return .success(EffectOutput(effects: effects))
    }
    
    static func resolveNumber(_ number: String, ctx: [EffectKey: String], state: State) -> Int {
        switch number {
        case .NUM_PLAYERS:
            return state.playOrder.count
            
        case .NUM_EXCESS_HAND:
            let actorObj = state.player(ctx[.ACTOR]!)
            return max(actorObj.hand.count - actorObj.handLimit, 0)
            
        default:
            guard let value = Int(number) else {
                fatalError(.numberValueInvalid(number))
            }
            
            return value
        }
    }
}
