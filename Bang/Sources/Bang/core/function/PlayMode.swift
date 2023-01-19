//
//  PlayMode.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//

/// Defining how a card is played
public protocol PlayMode {
    
    func resolve(_ playCtx: PlayContext, ctx: Game) -> Result<EventOutput, GameError>
    
    func isValid(_ playCtx: PlayContext, ctx: Game) -> Result<Void, GameError>
}
