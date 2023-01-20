//
//  IsNotHavingSameCardInPlay.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//
import GameRules

/// There is not the same card in play
public struct IsNotHavingSameCardInPlay: PlayReq, Equatable {

    public func match(_ ctx: Game, playCtx: PlayContext) -> Result<Void, GameError> {
        let actorObj = ctx.player(playCtx.actor)
        if actorObj.inPlay.contains(where: { $0.name == playCtx.playedCard.name }) {
            return .failure(.cannotHaveTheSameCardInPlay)
        }
        return .success
    }
}
