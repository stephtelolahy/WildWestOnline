//
//  GameFeatureAction+IsVisible.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 19/11/2025.
//

public extension GameFeature.Action {
    var isVisible: Bool {
        guard selectors.isEmpty else {
            return false
        }

        return NonStandardLogic.isActionVisible(self)
    }
}
