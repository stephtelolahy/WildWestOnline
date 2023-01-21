//
//  IsTargetNotHavingSameCardInPlay.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//
import GameRules

public struct IsTargetNotHavingSameCardInPlay: PlayReq, Equatable {
    
    public func match(_ ctx: Game, playCtx: PlayContext) -> Result<Void, GameError> {
        guard let target = playCtx.target else {
            return .failure(.noTargetSelected)
        }
        
        let targetObj = ctx.player(target)
        if targetObj.inPlay.contains(where: { $0.name == playCtx.playedCard.name }) {
            return .failure(.cannotHaveTheSameCardInPlay)
        }
        
        return .success
    }
}
