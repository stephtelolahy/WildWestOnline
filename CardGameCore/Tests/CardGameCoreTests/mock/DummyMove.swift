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
    
    func dispatch(in state: State) -> Result<MoveOutput, Error> {
        .success(MoveOutput(state: state))
    }
}
