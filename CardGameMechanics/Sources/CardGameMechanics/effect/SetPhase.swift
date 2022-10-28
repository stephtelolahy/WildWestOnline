//
//  SetPhase.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 05/06/2022.
//
import CardGameCore

/// Set  phase
public struct SetPhase: Effect, Equatable {
    let value: Int
    
    @EquatableNoop
    public var ctx: [ContextKey: Any]
    
    public init(value: Int, ctx: [ContextKey: Any] = [:]) {
        assert(value > 0)
        
        self.value = value
        self.ctx = ctx
    }
    
    public func resolve(in state: State) -> Result<EffectOutput, Error> {
        var state = state
        state.phase = value
        
        return .success(EffectOutput(state: state))
    }
}
