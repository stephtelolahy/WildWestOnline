//
//  Rule.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// All game rules

/// Getting distance between players
public protocol RuleDistance {
    func playersAt(_ range: Int, from player: String, in ctx: Game) -> [String]
}

/// Generating triggered effects, sorted by priority
public protocol RuleTrigger {
    func triggeredEffects(_ ctx: Game) -> [Event]?
}

/// Generating active moves
public protocol RuleActive {
    func activeMoves(_ ctx: Game) -> [Move]?
}
