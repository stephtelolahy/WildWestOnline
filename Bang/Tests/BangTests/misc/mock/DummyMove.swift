//
//  DummyMove.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
import Bang

struct DummyMove: Move, Equatable {
    let actor: String = ""
    
    func resolve(_ ctx: Game) -> Result<EventOutput, GameError> {
        .success(EventOutputImpl(state: ctx))
    }
}
