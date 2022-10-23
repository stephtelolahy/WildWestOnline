//
//  SetPhase.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 05/06/2022.
//
import CardGameCore
import UIKit

/// Set  phase
public struct SetPhase: Effect {
    
    private let value: Int
    
    public init(value: Int) {
        assert(value > 0)
        
        self.value = value
    }
    
    public func resolve(in state: State, ctx: [String: String]) -> Result<EffectOutput, Error> {
        var state = state
        state.phase = value
        
        return .success(EffectOutput(state: state))
    }
}
