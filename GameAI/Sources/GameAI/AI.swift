//
//  AI.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//
import GameCore

/// Agent that control a player in the game
public protocol AIAgent {
    
    /// Take control of any players
    func playAny(_ engine: Engine)
}

/// Strategy defining best move
public protocol AIStrategy {
    func bestMove(among moves: [Move], ctx: Game) -> Move
}
