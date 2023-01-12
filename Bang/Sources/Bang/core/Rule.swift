//
//  Rule.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// Distance rule
public protocol RuleDistance {
    func playersAt(_ distance: Int, from player: String, in ctx: Game) -> [String]
}

/// Playing card rule
public protocol RulePlay {
    func canPlay(_ card: Card, actor: String, in ctx: Game) -> Result<Void, GameError>
}

/// Game update by processing top queued effect
public protocol RuleUpdate {
    func update(_ ctx: Game) -> Game
}
