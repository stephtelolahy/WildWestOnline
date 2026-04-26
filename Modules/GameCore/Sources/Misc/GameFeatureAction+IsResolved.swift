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

        guard name != .queue else {
            return false
        }

        return true
    }
}
