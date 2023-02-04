//
//  RuleMock.swift
//  
//
//  Created by Hugues Telolahy on 20/01/2023.
//
import GameCore

public struct RuleMock: EngineRule {

    public init() {}
    
    public func triggered(_ ctx: Game) -> [Event]? {
        nil
    }
    
    public func active(_ ctx: Game) -> [Move]? {
        nil
    }
}
