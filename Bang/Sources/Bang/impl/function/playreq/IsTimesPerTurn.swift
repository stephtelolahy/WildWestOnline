//
//  IsTimesPerTurn.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

public struct IsTimesPerTurn: PlayReq, Equatable {
    private let maxTimes: Int
    
    public init(_ maxTimes: Int) {
        self.maxTimes = maxTimes
    }
    
    public func verify(_ ctx: Game) -> Result<Void, GameError> {
        // No limit
        guard maxTimes > 0 else {
            return .success(())
        }
        
        let playedTimes = ctx.played.filter { $0 == ctx.queueCard?.name }.count
        guard playedTimes < maxTimes else {
            return .failure(.reachedLimitPerTurn(maxTimes))
        }
        
        return .success(())
    }
}
