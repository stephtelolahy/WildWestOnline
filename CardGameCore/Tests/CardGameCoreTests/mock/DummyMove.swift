//
//  File.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 03/06/2022.
//

import CardGameCore

struct DummyMove: Move, Equatable {
    
    let id: String
    
    func dispatch(ctx: State) -> State? {
        var state = ctx
        state.lastEvent = self
        return state
    }
}
