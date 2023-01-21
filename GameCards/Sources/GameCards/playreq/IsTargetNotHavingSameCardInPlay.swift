//
//  IsTargetNotHavingSameCardInPlay.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//
import GameRules

struct IsTargetNotHavingSameCardInPlay: PlayReq, Equatable {
    
    func match(_ ctx: Game, playCtx: PlayContext) -> Result<Void, Error> {
        guard let target = playCtx.target else {
            return .failure(GameError.noTargetSelected)
        }
        
        let targetObj = ctx.player(target)
        if targetObj.inPlay.contains(where: { $0.name == playCtx.playedCard.name }) {
            return .failure(GameError.cannotHaveTheSameCardInPlay)
        }
        
        return .success
    }
}
