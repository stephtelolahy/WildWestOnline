//
//  AIStrategyRandom.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//

public struct AIStrategyRandom: AIStrategy {

    public init() {}
    
    public func bestMove(among moves: [Effect], ctx: Game) -> Effect {
        // swiftlint:disable:next force_unwrapping
        moves.randomElement()!
    }
}
