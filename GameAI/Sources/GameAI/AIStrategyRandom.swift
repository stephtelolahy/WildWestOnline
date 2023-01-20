//
//  AIStrategyRandom.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//
import GameRules

public struct AIStrategyRandom: AIStrategy {

    public init() {}
    
    public func bestMove(among moves: [Move], ctx: Game) -> Move {
        // swiftlint:disable:next force_unwrapping
        moves.randomElement()!
    }
}
