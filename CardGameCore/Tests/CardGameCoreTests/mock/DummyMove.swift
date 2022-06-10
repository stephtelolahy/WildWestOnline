//
//  DummyMove.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 03/06/2022.
//

import CardGameCore

struct DummyMove: Move, Equatable {
    
    let id: String
    
    let actor: String = ""
    
    func dispatch(state: State) -> MoveResult {
        .success(state: state, effects: nil, selectedArg: nil)
    }
}
