//
//  AI.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//

/// Agent that control a player in the game
public protocol AIAgent {
    
    /// Play any players
    func playAny(_ engine: Engine)
}

/// Strategy defining best move
public protocol AIStrategy {
    func bestMove(among moves: [Effect], ctx: Game) -> Effect
}
