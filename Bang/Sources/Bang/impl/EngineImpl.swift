//
//  EngineImpl.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
import Combine

public struct EngineImpl: Engine {
    
    public var state: CurrentValueSubject<Game, Never>
    
    public init(ctx: Game) {
        self.state = CurrentValueSubject(ctx)
    }
    
    public func input(_ move: Effect) {
        // TODO
        // add to state's queue
        // loop update state
    }
}
