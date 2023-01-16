//
//  NumExact.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// Exact number
public struct NumExact: ArgNumber, Equatable {
    private let value: Int
    
    public init(_ value: Int) {
        self.value = value
    }
    
    public func resolve(_ ctx: Game, playCtx: PlayContext) -> Result<Int, GameError> {
        .success(value)
    }
}
