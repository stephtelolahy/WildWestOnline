//
//  RuleMock.swift
//  
//
//  Created by Hugues Telolahy on 20/01/2023.
//
@testable import GameRules

struct RuleMock: Rule {
    
    func starting(_ ctx: Game) -> [Event]? {
        nil
    }
    
    func triggered(_ ctx: Game) -> [Event]? {
        nil
    }
    
    
    func active(_ ctx: Game) -> [Move]? {
        nil
    }
}
