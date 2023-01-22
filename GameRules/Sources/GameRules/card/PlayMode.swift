//
//  PlayMode.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//

/// Defining how a card is played
public protocol PlayMode {
    
    func resolve(_ eventCtx: EventContext, ctx: Game) -> Result<Game, Error>
    
    func isValid(_ eventCtx: EventContext, ctx: Game) -> Result<Void, Error>
}
