//
//  GameAction+Modifiers.swift
//  
//
//  Created by Hugues Telolahy on 07/05/2023.
//

public extension GameAction {
    static func group(@GameActionBuilder content: () -> [Self]) -> Self {
        .group(content())
    }
}
