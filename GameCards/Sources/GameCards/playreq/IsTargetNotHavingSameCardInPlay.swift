//
//  IsTargetNotHavingSameCardInPlay.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//
import GameCore

struct IsTargetNotHavingSameCardInPlay: PlayReq, Equatable {
    
    func match(_ ctx: Game, eventCtx: EventContext) -> Result<Void, Error> {
        guard let target = eventCtx.target else {
            return .failure(GameError.noTargetSelected)
        }
        
        let targetObj = ctx.player(target)
        if targetObj.inPlay.contains(where: { $0.name == eventCtx.card.name }) {
            return .failure(GameError.cannotHaveTheSameCardInPlay)
        }
        
        return .success
    }
}
