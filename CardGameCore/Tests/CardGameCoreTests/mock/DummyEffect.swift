//
//  DummyEffect.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 02/06/2022.
//
@testable import CardGameCore

struct DummyEffect: Effect {
    
    let id: String
    
    func resolve(ctx: State, cardRef: String) -> Result<State, Error> {
        var state = ctx
        state.lastEvent = self
        return .success(state)
    }
    
    func canResolve(ctx: State, actor: String) -> Result<Void, Error> {
        .success
    }
}
