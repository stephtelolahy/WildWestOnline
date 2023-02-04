//
//  NumExact.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
import GameCore

/// Exact number
public struct NumExact: ArgNumber, Equatable {
    private let value: Int
    
    public init(_ value: Int) {
        self.value = value
    }
    
    public func resolve(_ ctx: Game, eventCtx: EventContext) -> Result<Int, Error> {
        .success(value)
    }
}
