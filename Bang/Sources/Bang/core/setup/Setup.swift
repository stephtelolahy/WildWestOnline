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
    /// - Returns: Game
    func createGame(playersCount: Int, deck: [Card], abilities: [Card]) -> Game
}
