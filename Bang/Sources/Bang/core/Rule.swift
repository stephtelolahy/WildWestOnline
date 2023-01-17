//
//  Rule.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// All game rules

/// Getting distance between players
public protocol RuleDistance {
    func playersAt(_ distance: Int, from player: String, in ctx: Game) -> [String]
}

/// Verifying card playability
public protocol RulePlay {
    func canPlay(_ playCtx: PlayContext, in ctx: Game) -> Result<Void, GameError>
}

/// Generating triggered effects, sorted by priority
public protocol RuleTrigger {
    func triggeredEffects(_ ctx: Game) -> [EffectNode]?
}

/// Generating active moves
public protocol RuleActive {
    func activeMoves(_ ctx: Game) -> [Effect]?
}
