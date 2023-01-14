//
//  IsPlayersAtLeast.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// The minimum number of active players is X
public struct IsPlayersAtLeast: PlayReq, Equatable {
    private let count: Int
    
    public init(_ count: Int) {
        self.count = count
    }
    
    public func verify(_ ctx: Game) -> Result<Void, GameError> {
        guard ctx.playOrder.count >= count else {
            return .failure(.playersMustBeAtLeast(count))
        }
        
        return .success
    }
}
