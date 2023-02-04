//
//  EngineRule.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// Generating events for engine's loop
public protocol EngineRule {
    func triggered(_ ctx: Game) -> [Event]?
    func active(_ ctx: Game) -> [Move]?
}
