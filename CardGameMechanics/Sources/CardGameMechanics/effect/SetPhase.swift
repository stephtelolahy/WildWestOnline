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
    
    let value: Int
    
    public init(value: Int) {
        self.value = value
    }
    
    public func canResolve(ctx: State, actor: String) -> Result<Void, Error> {
        .success
    }
    
    public func resolve(ctx: State, cardRef: String) -> Result<State, Error> {
        var state = ctx
        state.phase = value
        state.lastEvent = self
        
        return .success(state)
    }
}
