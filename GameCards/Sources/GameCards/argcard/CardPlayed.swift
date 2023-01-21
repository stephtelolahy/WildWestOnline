//
//  CardPlayed.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//
import GameRules

/// Currently played card
public struct CardPlayed: ArgCard, Equatable {
    
    public func resolve(_ ctx: Game, playCtx: PlayContext, chooser: String, owner: String?) -> Result<ArgOutput, GameError> {
        .success(.identified([playCtx.playedCard.id]))
    }
}
