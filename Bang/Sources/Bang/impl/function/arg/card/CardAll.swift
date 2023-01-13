//
//  CardAll.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// all cards
public struct CardAll: ArgCard, Equatable {
    
    public init() {}
    
    public func resolve(_ ctx: Game, chooser: String, owner: String?) -> Result<ArgResolved, GameError> {
        guard let playerId = owner else {
            fatalError(.missingCardOwner)
        }
        
        let playerObj = ctx.player(playerId)
        let all = (playerObj.inPlay + playerObj.hand).map(\.id)
        guard !all.isEmpty else {
            return .failure(.playerHasNoCard(playerId))
        }
        
        return .success(.identified(all))
    }
}
