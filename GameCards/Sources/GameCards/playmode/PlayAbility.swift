//
//  PlayAbility.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//
import GameRules

/// Invoking ability
struct PlayAbility: PlayMode {
    
    func resolve(_ playCtx: PlayContext, ctx: Game) -> Result<Game, Error> {
        .success(ctx)
    }
    
    func isValid(_ playCtx: PlayContext, ctx: Game) -> Result<Void, Error> {
        /// verify playing effects not empty
        guard playCtx.playedCard.onPlay != nil else {
            return .failure(GameError.cardHasNoPlayingEffect)
        }
        
        return .success
    }
}
