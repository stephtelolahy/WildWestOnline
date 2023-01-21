//
//  Activate.swift
//  
//
//  Created by Hugues Telolahy on 17/01/2023.
//

/// Emit active moves
public struct Activate: Event, Equatable {
    @EquatableCast public var moves: [Move]
    
    public init(_ moves: [Move]) {
        self.moves = moves
    }
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        fatalError(InternalError.unexpected)
    }
}
