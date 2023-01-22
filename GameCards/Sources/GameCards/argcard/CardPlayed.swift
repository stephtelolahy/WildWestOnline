//
//  CardPlayed.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//
import GameRules

/// Currently played card
public struct CardPlayed: ArgCard, Equatable {
    
    public func resolve(_ ctx: Game, eventCtx: EventContext, chooser: String, owner: String?) -> Result<ArgOutput, Error> {
        .success(.identified([eventCtx.card.id]))
    }
}
