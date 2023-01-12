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
        fatalError()
    }
}
