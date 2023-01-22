//
//  CardAll.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
import GameRules

/// all cards
public struct CardAll: ArgCard, Equatable {
    
    public init() {}
    
    public func resolve(_ ctx: Game, eventCtx: EventContext, chooser: String, owner: String?) -> Result<ArgOutput, Error> {
        guard let playerId = owner else {
            fatalError(InternalError.missingCardOwner)
        }
        
        let playerObj = ctx.player(playerId)
        let all = (playerObj.inPlay + playerObj.hand).map(\.id)
        guard !all.isEmpty else {
            return .failure(GameError.playerHasNoCard(playerId))
        }
        
        return .success(.identified(all))
    }
}
