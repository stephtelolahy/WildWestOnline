//
//  MoveMock.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
@testable import GameRules

struct MoveMock: Move, Equatable {
    let actor: String = ""
    
    func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        .success(EventOutputImpl(state: ctx))
    }
    
    func isValid(_ ctx: Game) -> Result<Void, Error> {
        .success(())
    }
}
