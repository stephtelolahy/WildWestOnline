//
//  Rule.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// All game rules

public protocol RuleSetup {
    /// Create game
    /// - Parameters:
    ///   - playersCount: number of players
    ///   - deck: all deck cards
    ///   - abilities: common player abilities
    /// - Returns: Game
    func createGame(playersCount: Int, deck: [Card], abilities: [Card]) -> Game
}

/// Getting distance between players
public protocol RuleDistance {
    func playersAt(_ distance: Int, from player: String, in ctx: Game) -> [String]
}

/// Verifying card playability
public protocol RulePlay {
    func canPlay(_ card: Card, actor: String, in ctx: Game) -> Result<Void, GameError>
}

/// Generating triggered moves, sorted by priority
public protocol RuleTrigger {
    func triggeredMoves(_ ctx: Game) -> [Effect]
}

/// Generating active moves
public protocol RuleActive {
    func activeMoves(_ ctx: Game) -> [Effect]
}
