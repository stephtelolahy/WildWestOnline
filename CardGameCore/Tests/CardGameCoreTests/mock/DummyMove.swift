//
//  DummyMove.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 03/06/2022.
//

import CardGameCore

struct DummyMove: Move {
    
    let id: String
    
    let actor: String = ""
    
    var ctx: [String: Any] = [:]
    
    func resolve(in state: State) -> Result<EffectOutput, Error> {
        .success(EffectOutput())
    }
}
