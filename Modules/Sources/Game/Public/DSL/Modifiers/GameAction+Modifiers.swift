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

    var isRenderable: Bool {
        switch self {
        case .play,
             .resolve,
             .group:
            return false

        default:
            return true
        }
    }
}
