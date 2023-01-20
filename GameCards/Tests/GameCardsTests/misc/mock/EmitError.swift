//
//  EmitError.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
import GameRules

struct EmitError: Effect, Equatable {
    let error: GameError
    @EquatableIgnore var playCtx: PlayContext = PlayContextImpl()
    
    func resolve(_ ctx: Game) -> Result<EventOutput, GameError> {
        .failure(error)
    }
}
