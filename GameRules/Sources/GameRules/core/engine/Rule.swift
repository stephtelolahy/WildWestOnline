//
//  Rule.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

/// All game rules

/// Generating events for engine's loop
public protocol Rule {
    func starting(_ ctx: Game) -> [Event]?
    func triggered(_ ctx: Game) -> [Event]?
    func active(_ ctx: Game) -> [Move]?
}
