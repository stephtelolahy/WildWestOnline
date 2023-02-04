//
//  IsNotHavingSameCardInPlay.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//
import GameCore

/// There is not the same card in play
struct IsNotHavingSameCardInPlay: PlayReq, Equatable {

    func match(_ ctx: Game, eventCtx: EventContext) -> Result<Void, Error> {
        let actorObj = ctx.player(eventCtx.actor)
        if actorObj.inPlay.contains(where: { $0.name == eventCtx.card.name }) {
            return .failure(GameError.cannotHaveTheSameCardInPlay)
        }
        return .success
    }
}
