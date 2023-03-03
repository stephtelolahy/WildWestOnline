//
//  MockCardGameEngineRule.swift
//  
//
//  Created by Hugues Telolahy on 03/03/2023.
//
@testable import CardGame
import GameDSL

struct MockCardGameEngineRule: CardGameEngineRule {

    func triggered(_ ctx: Game) -> [Event]? {
        nil
    }

    func active(_ ctx: Game) -> [Event]? {
        nil
    }
}
