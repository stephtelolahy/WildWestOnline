//
//  DummyEffect.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 02/06/2022.
//
@testable import CardGameCore

struct DummyEffect: Effect {
    let id: String
    var ctx: [String: Any] = [:]
    
    func resolve(in state: State) -> Result<EffectOutput, Error> {
        .success(EffectOutput())
    }
}
