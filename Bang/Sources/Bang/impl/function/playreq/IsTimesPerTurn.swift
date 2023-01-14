//
//  IsTimesPerTurn.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// The maximum times per turn a card may be played is X
public struct IsTimesPerTurn: PlayReq, Equatable {
    private let maxTimes: Int
    
    public init(_ maxTimes: Int) {
        self.maxTimes = maxTimes
    }
    
    public func match(_ ctx: Game) -> Result<Void, GameError> {
        // No limit
        guard maxTimes > 0 else {
            return .success
        }
        
        let playedTimes = ctx.played.filter { $0 == ctx.currentCard?.name }.count
        guard playedTimes < maxTimes else {
            return .failure(.reachedLimitPerTurn(maxTimes))
        }
        
        return .success
    }
}
