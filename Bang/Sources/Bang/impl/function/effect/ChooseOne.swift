//
//  ChooseOne.swift
//  
//
//  Created by Hugues Telolahy on 17/01/2023.
//

/// Choose one of pending actions to proceed effect resolving
public struct ChooseOne: Effect, Equatable {
    private var options: [Choose]
    
    public init(_ options: [Choose]) {
        self.options = options
    }
    
    public func resolve(_ ctx: Game, playCtx: PlayContext) -> Result<EffectOutput, GameError> {
        fatalError(.unexpected)
    }
    
    public func getOptions() -> [Choose] {
        options
    }
}
