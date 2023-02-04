//
//  RuleDistance.swift
//  
//
//  Created by Hugues Telolahy on 20/01/2023.
//
import GameCore

/// Getting distance between players
protocol RuleDistance {
    func playersAt(_ range: Int, from player: String, in ctx: Game) -> [String]
}
