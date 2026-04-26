//
//  GameFeatureAction+IsResolved.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 19/11/2025.
//

public extension GameFeature.Action {
    var isResolved: Bool {
        guard selectors.isEmpty else {
            return false
        }

        switch name {
        case .queue, .dummy:
            return false

        default:
            return true
        }
    }
}
