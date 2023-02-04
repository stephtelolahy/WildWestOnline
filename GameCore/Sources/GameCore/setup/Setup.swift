//
//  Setup.swift
//  
//
//  Created by Hugues Telolahy on 17/01/2023.
//

public protocol Setup {
    /// Create game
    /// - Parameters:
    ///   - playersCount: number of players
    ///   - deck: all deck cards
    ///   - abilities: common player abilities
    ///   - figures: all figures
    /// - Returns: Game
    func createGame(playersCount: Int, deck: [Card], abilities: [Card], figures: [Card]) -> Game
    
    /// Get starting events
    func starting(_ ctx: Game) -> [Event]
}
