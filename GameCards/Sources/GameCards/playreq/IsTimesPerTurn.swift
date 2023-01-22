//
//  IsTimesPerTurn.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
import GameRules

/// The maximum times per turn a card may be played is X
struct IsTimesPerTurn: PlayReq, Equatable {
    private let maxTimes: Int
    
    init(_ maxTimes: Int) {
        self.maxTimes = maxTimes
    }
    
    func match(_ ctx: Game, eventCtx: EventContext) -> Result<Void, Error> {
        // No limit
        guard maxTimes > 0 else {
            return .success
        }
        
        let playedTimes = ctx.played.filter { $0 == eventCtx.card.name }.count
        guard playedTimes < maxTimes else {
            return .failure(GameError.reachedLimitPerTurn(maxTimes))
        }
        
        return .success
    }
}
