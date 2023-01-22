//
//  RuleMock.swift
//  
//
//  Created by Hugues Telolahy on 20/01/2023.
//
@testable import GameRules

struct RuleMock: EngineRule {
    
    func triggered(_ ctx: Game) -> [Event]? {
        nil
    }
    
    func active(_ ctx: Game) -> [Move]? {
        nil
    }
}
