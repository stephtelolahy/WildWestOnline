//
//  IsTimesPerTurn.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
import GameRules

/// The maximum times per turn a card may be played is X
public struct IsTimesPerTurn: PlayReq, Equatable {
    private let maxTimes: Int
    
    public init(_ maxTimes: Int) {
        self.maxTimes = maxTimes
    }
    
    public func match(_ ctx: Game, playCtx: PlayContext) -> Result<Void, GameError> {
        // No limit
        guard maxTimes > 0 else {
            return .success
        }
        
        let playedTimes = ctx.played.filter { $0 == playCtx.playedCard.name }.count
        guard playedTimes < maxTimes else {
            return .failure(.reachedLimitPerTurn(maxTimes))
        }
        
        return .success
    }
}
