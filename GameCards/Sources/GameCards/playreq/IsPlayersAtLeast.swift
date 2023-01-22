//
//  IsPlayersAtLeast.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
import GameRules

/// The minimum number of active players is X
struct IsPlayersAtLeast: PlayReq, Equatable {
    private let count: Int
    
    init(_ count: Int) {
        self.count = count
    }
    
    func match(_ ctx: Game, eventCtx: EventContext) -> Result<Void, Error> {
        guard ctx.playOrder.count >= count else {
            return .failure(GameError.playersMustBeAtLeast(count))
        }
        
        return .success
    }
}
