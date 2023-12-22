//
//  GameAction+Modifiers.swift
//  
//
//  Created by Hugues Telolahy on 07/05/2023.
//

public extension GameAction {
    static let nothing: Self = .group([])

    static func group(@GameActionBuilder content: () -> [Self]) -> Self {
        precondition(content().count >= 2)
        return .group(content())
    }
}
